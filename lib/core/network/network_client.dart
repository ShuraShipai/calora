import 'dart:io';

import 'package:calora/core/network/network_connectivity_service.dart';
import 'package:calora/core/network/network_exception.dart';
import 'package:dio/dio.dart';

abstract interface class NetworkClient {
  Future<Map<String, dynamic>> getJson(Uri uri, {Map<String, String>? headers});
}

class DioNetworkClient implements NetworkClient {
  factory DioNetworkClient({
    required NetworkConnectivityService connectivity,
    Dio? dio,
  }) => DioNetworkClient._(connectivity, dio);

  DioNetworkClient._(this._connectivity, Dio? dio)
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 15),
            ),
          );

  static const _retryDelay = Duration(milliseconds: 500);

  final NetworkConnectivityService _connectivity;
  final Dio _dio;

  @override
  Future<Map<String, dynamic>> getJson(
    Uri uri, {
    Map<String, String>? headers,
  }) async {
    if (!await _connectivity.isConnected) {
      throw const NetworkException.offline();
    }

    try {
      final response = await _getWithRetry(uri, headers: headers);
      final body = response.data;
      if (body is Map<String, dynamic>) return body;
      if (body is Map) {
        return body.map(
          (key, value) => MapEntry<String, dynamic>(key.toString(), value),
        );
      }
      throw const NetworkException.unexpected();
    } on NetworkException {
      rethrow;
    } on DioException catch (error) {
      throw _mapDioException(error);
    } on SocketException {
      throw const NetworkException.offline();
    } on Object {
      throw const NetworkException.unexpected();
    }
  }

  Future<Response<dynamic>> _getWithRetry(
    Uri uri, {
    Map<String, String>? headers,
  }) async {
    try {
      return await _get(uri, headers: headers);
    } on DioException catch (error) {
      if (!_isTransientServerError(error)) rethrow;
      await Future<void>.delayed(_retryDelay);
      return _get(uri, headers: headers);
    }
  }

  Future<Response<dynamic>> _get(Uri uri, {Map<String, String>? headers}) =>
      _dio.getUri<dynamic>(uri, options: Options(headers: headers));

  bool _isTransientServerError(DioException error) {
    final statusCode = error.response?.statusCode;
    return statusCode == 429 || (statusCode != null && statusCode >= 500);
  }

  NetworkException _mapDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return const NetworkException.timeout();
      case DioExceptionType.connectionError:
        return const NetworkException.offline();
      case DioExceptionType.badResponse:
        return const NetworkException.server();
      case DioExceptionType.cancel:
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          return const NetworkException.offline();
        }
        return const NetworkException.unexpected();
    }
  }
}
