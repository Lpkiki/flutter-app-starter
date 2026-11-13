import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Shared API boundary. Tokens remain in memory and expire after eight hours.
class ApiClient {
  ApiClient({Dio? dio})
    : dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: apiBaseUrl,
              connectTimeout: const Duration(seconds: 15),
              receiveTimeout: const Duration(seconds: 15),
            ),
          );
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8080/api',
  );
  final Dio dio;
  String? token;
  VoidCallback? onUnauthorized;
  Future<dynamic> request(String method, String path, {Object? data}) async {
    final uri = Uri.parse(dio.options.baseUrl);
    const localHosts = {'localhost', '127.0.0.1', '10.0.2.2'};
    if (uri.scheme != 'https' &&
        (kReleaseMode || !localHosts.contains(uri.host))) {
      throw StateError('HTTPS required');
    }
    try {
      final result = await dio.request<dynamic>(
        path,
        data: data,
        options: Options(
          method: method,
          headers: {if (token != null) 'Authorization': 'Bearer $token'},
        ),
      );
      return result.data['data'];
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 && path != '/auth/login') {
        token = null;
        onUnauthorized?.call();
      }
      rethrow;
    }
  }
}
