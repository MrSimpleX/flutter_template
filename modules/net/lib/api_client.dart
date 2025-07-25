import 'package:dio/dio.dart';
import 'package:net/bean/api_result.dart';
import 'package:net/interceptor/log_interceptor.dart';
import 'package:net/interceptor/token_interceptor.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  late Dio _dio;

  String _baseUrl = 'http://172.0.0.1';
  static const int connectTimeout = 5;
  static const int receiveTimeout = 5;

  //初始化
  void init() {
    _dio = Dio();

    //基础配置
    _dio.options = BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: Duration(seconds: connectTimeout),
      receiveTimeout: Duration(seconds: receiveTimeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    //拦截器
    _dio
      ..interceptors.add(LoggingInterceptor())
      ..interceptors.add(TokenInterceptor());
  }

  setBaseUrl(String baseUrl) {
    _baseUrl = baseUrl;
    _dio.options.baseUrl = baseUrl;
  }

  String getBaseUrl() {
    return _baseUrl;
  }

  /// GET
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.get(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// POST请求
  Future<ApiResult<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    final post = await _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );

    return ApiResult.fromJson(post.data, fromJson);
  }
}
