import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../generated/json/base/json_convert_content.dart';

///data指的是返回的数据
typedef InterceptorResponse = Future<T?> Function<T>(dynamic data);

class DioConfig {
  static const Map<String, dynamic> headers = {
    'Content-Type': 'application/json; charset=utf-8',
  };

  static String unKnowError = "未知错误";
  static String unKnowErrorJson = "Json解析出错";

  ///服务器返回的格式默认为
  ///{"code":200,"msg:"成功","data":{}/[]}
  static String code = "code";
  static String msg = "msg";

  ///data参数指的是返回的完整的数据体,需自行处理除状态行外的其他状态
  static (bool, T?) interceptorSpecialTypeResponse<T>(dynamic data) {
    var responseData = data;

    if (T.toString() == "void") {
      return (true, null);
    }

    if (T.toString() == "String") {
      return (true, jsonEncode(responseData) as T?);
    }
    if (T.toString() == "dynamic") {
      return (true, responseData as T?);
    }
    return (false, null);
  }

  static connectTimeout() => const Duration(milliseconds: 100000);

  static receiveTimeout() => const Duration(milliseconds: 100000);

  static sendTimeout() => const Duration(milliseconds: 100000);

  static interceptors() => [
    PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: true,
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
    _dio.interceptors.addAll(DioConfig.interceptors());
  }

  Dio get dio => _dio;

  Future<T?> get<T>(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        CancelToken? cancelToken,
        Options? options,
        ProgressCallback? onReceiveProgress,
        ProgressCallback? onSendProgress,
        bool isolate = true,
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

  Future<T?> delete<T>(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        CancelToken? cancelToken,
        Options? options,
        ProgressCallback? onReceiveProgress,
        ProgressCallback? onSendProgress,
        bool isolate = true,
      }) async {
    return request<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
      onSendProgress: onSendProgress,
      options: options ?? Options(method: 'DELETE'),
      isolate: isolate,
    );
  }

  Future<T?> uploadImage<T>(
      String url,
      Uint8List data,
      String mimeType,
      Function(double)? onUploadProgress,
      ) async {
    try {
      var response = await dio.put(
        url,
        data: data,
        options: Options(
          contentType: mimeType,
          headers: {
            'Content-Length': data.length.toString(),
            'Content-Type': mimeType,
          },
        ),
      );

      return _handleResponseData<T>(response, false, null);
    } on DioException catch (e) {
      throw ApiException(code: e.response?.statusCode ?? 0, message: e.message ?? DioConfig.unKnowError);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(code: -1000, message: e.toString());
    }
  }

  //支持分段上传大文件
  Future<void> upload(
      String url,
      File file,
      String mimeType,
      Function(double)? onUploadProgress,
      ) async {
    try {
      var req = await HttpClient().putUrl(Uri.parse(url));
      req.headers.add('Content-Length', file.lengthSync().toString());
      req.headers.add('Content-Type', mimeType);
      // 读文件
      var s = await file.open();
      var x = 0;
      var size = file.lengthSync();
      var chunkSize = 8388608 * 5;
      while (x < size) {
        var len = size - x >= chunkSize ? chunkSize : size - x;
        var val = s.readSync(len).toList();
        x = x + len;
        // 加入http发送缓冲区
        req.add(val);
        // 立即发送并清空缓冲区
        await req.flush();
      }
      await s.close();
      await req.close();
      await req.done;
    } on DioException catch (e) {
      throw ApiException(code: e.response?.statusCode ?? 0, message: e.message ?? DioConfig.unKnowError);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(code: -1000, message: e.toString());
    }
  }

  Future<T?> post<T>(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        CancelToken? cancelToken,
        Options? options,
        ProgressCallback? onReceiveProgress,
        ProgressCallback? onSendProgress,
        bool isolate = true,
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
      try {
        int code = e.response?.statusCode ?? -1;
        String msg;
        if (e.response?.data is String) {
          msg = jsonDecode(e.response?.data ?? "{}")[DioConfig.msg] ?? e.message;
        } else {
          msg = e.response?.data[DioConfig.msg] ?? e.message;
        }
        throw ApiException(code: code, message: msg);
      } catch (e) {
        throw ApiException(code: -1000, message: e.toString());
      }
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
    var data = response.data;
    if (code >= 200 && code < 300) {
      if (interceptorResponse != null) {
        return await interceptorResponse(data);
      } else {
        var (interceptorSuccess, result) = DioConfig.interceptorSpecialTypeResponse<T>(data);
        if (interceptorSuccess) {
          return result;
        }
        if (isolate) {
          return await compute<dynamic, T?>((data) => JsonConvert.fromJsonAsT<T>(data), data);
        } else {
          return JsonConvert.fromJsonAsT<T>(data);
        }
      }
    } else {
      int code = response.statusCode ?? -1;
      String message = data[DioConfig.msg] ?? DioConfig.unKnowError;
      throw ApiException(code: code, message: message);
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

  @override
  String toString() {
    return message;
  }
}
