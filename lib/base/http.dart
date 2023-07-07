import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_starter/generated/json/base/json_convert_content.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

///data指的是返回的数据
typedef InterceptorResponse = Future<T?> Function<T>(dynamic data);

class DioConfig {
  static const Map<String, dynamic> headers = {
    'Content-Type': 'application/json; charset=utf-8',
  };

  static String unKnowError = "未知错误";
  static String unKnowErrorJson = "Json解析出错";

  ///data指的是返回的数据
  static (bool, T?) interceptorSpecialTypeResponse<T>(dynamic data) {
    if (T.toString() == "String") {
      return (true, jsonEncode(data["data"]) as T?);
    }
    if (T.toString() == "dynamic") {
      return (true, data["data"] as T?);
    }
    return (false, null);
  }

  static connectTimeout() => const Duration(milliseconds: 10000);

  static receiveTimeout() => const Duration(milliseconds: 10000);

  static sendTimeout() => const Duration(milliseconds: 10000);

  static interceptors() => [
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
      ];
}

class Http {
  static late Dio _dio;

  static void init({Dio? dio, String? baseUrl}) {
    if (dio != null) {
      _dio = dio;
      return;
    }
    _dio = Dio(BaseOptions(
      connectTimeout: DioConfig.connectTimeout(),
      receiveTimeout: DioConfig.receiveTimeout(),
      sendTimeout: DioConfig.sendTimeout(),
    ));
    _dio.options.baseUrl = baseUrl ?? '';
    _dio.options.headers = DioConfig.headers;
    // _dio.interceptors.addAll(DioConfig.interceptors());
  }

  Future<T?> get<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
    ProgressCallback? onReceiveProgress,
    ProgressCallback? onSendProgress,
    bool isolate = false,
  }) async {
    return request<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
      onSendProgress: onSendProgress,
      options: options ?? Options(method: 'GET'),
      isolate: isolate,
    );
  }

  Future<T?> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
    ProgressCallback? onReceiveProgress,
    ProgressCallback? onSendProgress,
    bool isolate = false,
  }) async {
    return request<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
      onSendProgress: onSendProgress,
      options: options ?? Options(method: 'POST'),
      isolate: isolate,
    );
  }

  Future<T?> request<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
    ProgressCallback? onReceiveProgress,
    ProgressCallback? onSendProgress,
    bool isolate = false,
    InterceptorResponse? interceptorResponse,
  }) async {
    try {
      var response = await _request(
        path,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        onSendProgress: onSendProgress,
        options: options ?? Options(method: 'GET'),
      );
      return _handleResponseData<T>(response, isolate, interceptorResponse);
    } on DioException catch (e) {
      throw ApiException(code: e.response?.statusCode ?? 0, message: e.message ?? DioConfig.unKnowError);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(code: -1000, message: e.toString());
    }
  }

  Future<Response> _request(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    ProgressCallback? onSendProgress,
  }) async {
    return _dio.request(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
      onSendProgress: onSendProgress,
    );
  }

  Future<T?> _handleResponseData<T>(Response response, bool isolate, InterceptorResponse? interceptorResponse) async {
    int code = response.statusCode ?? 0;
    if (code >= 200 && code < 300) {
      var data = response.data;
      if (data is Map) {
        int code = data["code"] ?? -1;
        String message = data["message"] ?? DioConfig.unKnowError;

        if (code != 200) {
          throw ApiException(code: -1002, message: message, data: data);
        }
        if (interceptorResponse != null) {
          return await interceptorResponse(data);
        } else {
          var (interceptorSuccess, result) = DioConfig.interceptorSpecialTypeResponse<T>(data);
          if (interceptorSuccess) {
            return result;
          }
          if (isolate) {
            return await compute<dynamic, T?>((data) => JsonConvert.fromJsonAsT<T>(data), data["data"]);
          } else {
            return JsonConvert.fromJsonAsT<T>(data["data"]);
          }
        }
      } else {
        throw ApiException(code: -1002, message: DioConfig.unKnowErrorJson);
      }
    } else {
      throw ApiException(code: code, message: response.statusMessage ?? DioConfig.unKnowError);
    }
  }
}

class ApiException implements Exception {
  int code;
  String message;
  dynamic data;

  ApiException({
    required this.code,
    required this.message,
    this.data,
  });
}
