import 'package:flutter/foundation.dart';
import 'dart:developer' as developer;

import 'package:logger/logger.dart';

class AppLog {
  static AppLog? _instance;
  static AppLog get instance => _instance ??= AppLog._();

  late final Logger _logger;

  AppLog._() {
    _logger = Logger(
      printer: SimplePrinter(),
      output: _FileOutput(),
      filter: kDebugMode ? DevelopmentFilter() : ProductionFilter(),
    );
  }

  // 基础日志方法
  void d(dynamic msg, [dynamic error, StackTrace? trace]) =>
      _logger.d(msg, error: error, stackTrace: trace);
  void i(dynamic msg, [dynamic error, StackTrace? trace]) =>
      _logger.i(msg, error: error, stackTrace: trace);
  void w(dynamic msg, [dynamic error, StackTrace? trace]) =>
      _logger.w(msg, error: error, stackTrace: trace);
  void e(dynamic msg, [dynamic error, StackTrace? trace]) =>
      _logger.e(msg, error: error, stackTrace: trace);

  /// 网络请求日志
  void network(String method, String url, {int? code, Duration? time}) {
    final status = code != null && code >= 400 ? '❌' : '✅';
    final duration = time != null ? ' (${time.inMilliseconds}ms)' : '';
    i('🌐 $status $method $url$duration');
  }

  /// 用户行为日志
  void action(String action, [Map<String, dynamic>? params]) {
    i('👤 $action${params != null ? ' $params' : ''}');
  }
}

/// 简化的日志打印器
class _SimplePrinter extends LogPrinter {
  static const _colors = {
    Level.debug: '\x1B[36m', // 青色
    Level.info: '\x1B[32m', // 绿色
    Level.warning: '\x1B[33m', // 黄色
    Level.error: '\x1B[31m', // 红色
  };

  static const _emojis = {
    Level.debug: '🐛',
    Level.info: 'ℹ️',
    Level.warning: '⚠️',
    Level.error: '❌',
  };

  @override
  List<String> log(LogEvent event) {
    final time = DateTime.now().toString().substring(11, 19);
    final color = _colors[event.level] ?? '';
    final emoji = _emojis[event.level] ?? '';
    final reset = '\x1B[0m';

    var output = ['$color$emoji [$time] ${event.message}$reset'];

    if (event.error != null) {
      output.add('$color   Error: ${event.error}$reset');
    }

    return output;
  }
}

/// 文件输出处理
class _FileOutput extends LogOutput {
  String? _logPath;

  _FileOutput() {
    _initFile();
  }

  void _initFile() async {
    // if (kIsWeb) return;

    // try {
    //   final dir = await getApplicationDocumentsDirectory();
    //   final date = DateTime.now().toString().substring(0, 10);
    //   _logPath = '${dir.path}/app_$date.log';
    // } catch (_) {}
  }

  @override
  void output(OutputEvent event) {
    // 控制台输出
    event.lines.forEach(developer.log);

    // 文件输出
    // if (_logPath != null) {
    //   try {
    //     final content = event.lines.join('\n') + '\n';
    //     File(_logPath!).writeAsStringSync(content, mode: FileMode.append);
    //   } catch (_) {}
    // }
  }
}

/// 性能计时器
class Timer {
  final String name;
  final Stopwatch _sw = Stopwatch()..start();

  Timer(this.name);

  void stop() {
    _sw.stop();
    AppLog.instance.i('⚡ $name: ${_sw.elapsedMilliseconds}ms');
  }
}

/// 扩展方法
extension QuickLog on Object {
  void log() => AppLog.instance.i(this);
  void logError() => AppLog.instance.e(this);
  void logE(err) => AppLog.instance.e(err);
}
