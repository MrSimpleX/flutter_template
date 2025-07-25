import 'package:dio/dio.dart';
import 'package:shared/di/provider_container.dart';
import 'package:shared/di/providers.dart';
import 'package:shared/service/i_logger.dart';

class LoggingInterceptor extends Interceptor {
  final Map<RequestOptions, DateTime> _startTimes = {};

  final ILogger _logger = GlobalProviderContainer.read(loggerProvider);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _startTimes[options] = DateTime.now();
    StringBuffer request = StringBuffer()
      ..write('[Request] URL: ${options.uri}')
      ..write('\n')
      ..write('Method: ${options.method}')
      ..write('\n')
      ..write('Headers: ${options.headers}')
      ..write('\n')
      ..write('Data: ${options.data}');

    _logger.error(request.toString());

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final startTime = _startTimes.remove(response.requestOptions);

    String responseMsg = '[Response] URL: ${response.requestOptions.uri}';
    if (startTime != null) {
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);
      responseMsg =
          '[Response] URL: ${response.requestOptions.uri} (${duration.inMilliseconds}ms)';
    }
    StringBuffer result = StringBuffer()
      ..write(responseMsg)
      ..write('\n')
      ..write('Status Code: ${response.statusCode}')
      ..write('\n')
      ..write('Body: ${response.data}');

    _logger.error(result.toString());

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final startTime = _startTimes.remove(err.requestOptions);

    String responseMsg = '[Error] URL: ${err.requestOptions.uri}';
    if (startTime != null) {
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);
      responseMsg =
          '[Error] URL: ${err.requestOptions.uri} (${duration.inMilliseconds}ms)';
    }
    StringBuffer errResult = StringBuffer()
      ..write(responseMsg)
      ..write('\n')
      ..write('Type: ${err.type}')
      ..write('\n')
      ..write('Message: ${err.message}');

    if (err.response != null) {
      errResult.write('Response Status Code: ${err.response?.statusCode}');
      errResult.write('Response Data: ${err.response?.data}');
    }

    _logger.error(errResult.toString());

    super.onError(err, handler);
  }
}
