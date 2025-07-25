import 'dart:convert';

class ApiResult<T> {
  final String errCode;
  final int? rstCode;
  final String errMessage;
  final bool success;
  final String? timeStamp;
  final T? data;

  ApiResult({
    required this.errCode,
    this.rstCode,
    required this.errMessage,
    required this.success,
    this.timeStamp,
    this.data,
  });

  factory ApiResult.fromJson(
    dynamic json,
    T Function(Map<String, dynamic>)? fromJson,
  ) {
    final map = switch (json) {
      String() => (jsonDecode(json) as Map?)?.cast<String, dynamic>() ?? {},
      Map() => json.cast<String, dynamic>(),
      null => {},
      _ => {},
    };

    T? data;
    if (map['data'] case final dataValue?) {
      if (fromJson != null) {
        data = switch (dataValue) {
          List() =>
            dataValue.map((e) => fromJson(e as Map<String, dynamic>)).toList()
                as T?,
          Map() => fromJson(dataValue as Map<String, dynamic>),
          _ => null,
        };
      } else {
        data = dataValue as T?;
      }
    }

    return ApiResult<T>(
      errCode: map['errCode'] as String? ?? "err",
      errMessage: map['errMessage'] as String? ?? '未知错误',
      rstCode: map['rstCode'] as int?,
      success: map['success'] as bool? ?? false,
      timeStamp: map['timeStamp'] as String?,
      data: data,
    );
  }
}
