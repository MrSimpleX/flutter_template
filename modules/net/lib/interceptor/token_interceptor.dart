import 'package:dio/dio.dart';
import 'package:net/api_client.dart';
import 'package:shared/di/provider_container.dart';
import 'package:shared/di/providers.dart';
import 'package:shared/service/i_token.dart';

class TokenInterceptor extends QueuedInterceptorsWrapper {
  //新增跳过 Authorization 请求列表
  static final Set<String> _excludedPaths = {};

  final IToken _token = GlobalProviderContainer.read(tokenProvider);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!_shouldAddAuthorization(options.path)) {
      handler.next(options);
      return;
    }
    final token = '';

    if (token.isNotEmpty) {
      options.headers['Authorization'] = token;
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401 &&
        _shouldAddAuthorization(err.requestOptions.path)) {
      try {
        final refreshState = await _refreshToken();
        if (!refreshState) {
          _navigateToLogin();
          handler.next(err);
          return;
        }

        final response = await _retryRequest(err.requestOptions, _token);
        handler.resolve(response);
      } catch (e) {
        handler.next(err);
      } finally {}
    } else {
      handler.next(err);
    }
  }

  /// 检查是否需要添加Authorization头
  bool _shouldAddAuthorization(String path) {
    // 检查是否在排除列表中
    for (final excludedPath in _excludedPaths) {
      if (excludedPath.endsWith('/')) {
        // 如果排除路径以'/'结尾，检查是否为路径前缀
        if (path.startsWith(excludedPath)) {
          return false;
        }
        if (path.contains(excludedPath)) {
          return false;
        }
      } else {
        // 精确匹配路径
        if (path == excludedPath) {
          return false;
        }
        if (path.contains(excludedPath)) {
          return false;
        }
      }
    }
    return true;
  }

  ///token 刷新
  Future<bool> _refreshToken() async {
    try {
      final refreshDio = Dio();
      refreshDio.options = BaseOptions(
        baseUrl: ApiClient().getBaseUrl(),
        connectTimeout: Duration(seconds: 3),
        receiveTimeout: Duration(seconds: 3),
      );

      // String code = SPUtils().getString(PaltformKey.DEVICE_CODE) ?? '';
      // String loginCode =
      //     SPUtils().getString(PaltformKey.DEVICE_LOGIN_CODE) ?? '';

      // final resopnse = await refreshDio.post(
      //   ApiAddress.DEVICE_AUTHORIZE,
      //   data: {"deviceCode": code, "code": loginCode},
      //   options: Options(
      //     headers: {'Content-Type': 'x-www-form-urlencoded;charset=UTF-8'},
      //   ),
      // );

      // if (resopnse.statusCode == 200) {
      //   final data = resopnse.data;
      //   final newToken = data['access_token'].toString();
      //   SPUtils().setString(PaltformKey.API_TOKEN, newToken);
      //   return true;
      // }
    } catch (e) {
      //Token 刷新异常
    }
    return false;
  }
}

///重试请求
Future<Response> _retryRequest(
  RequestOptions requestOptions,
  IToken tokenProvider,
) async {
  final token = tokenProvider.token ?? '';

  if (token.isNotEmpty) {
    requestOptions.headers['Authorization'] = 'Bearer $token';
  }

  // 创建新的Dio实例避免触发拦截器
  final retryDio = Dio();
  retryDio.options = BaseOptions(
    baseUrl: ApiClient().getBaseUrl(),
    connectTimeout: Duration(seconds: ApiClient.connectTimeout),
    receiveTimeout: Duration(seconds: ApiClient.receiveTimeout),
  );

  return await retryDio.fetch(requestOptions);
}

void _navigateToLogin() {}
