import 'package:core/utils/app_log.dart';
import 'package:shared/shared.dart';

class LoggerProviderImpl implements ILogger {
  @override
  void debug(String message, [error, StackTrace? stackTrace]) {
    AppLog.instance.d(message, error, stackTrace);
  }

  @override
  void error(String message, [error, StackTrace? stackTrace]) {
    AppLog.instance.e(message, error, stackTrace);
  }

  @override
  void info(String message, [error, StackTrace? stackTrace]) {
    AppLog.instance.i(message, error, stackTrace);
  }

  @override
  void warning(String message, [error, StackTrace? stackTrace]) {
    AppLog.instance.w(message, error, stackTrace);
  }
}
