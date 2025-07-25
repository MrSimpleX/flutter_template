import 'package:shared/shared.dart';

//服务注入定义

final loggerProvider = Provider<ILogger>((ref) {
  throw UnimplementedError('Logger must be overridden before use');
});

final tokenProvider = Provider<IToken>((ref) {
  throw UnimplementedError('Token must be overridden before use');
});
