import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabulo/core/env.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();

  factory DioClient() {
    return _instance;
  }

  late final Dio dio;

  DioClient._internal() {
    if (baseUrl.trim().isEmpty) {
      assert(false, '💥 baseUrl est vide dans dio_client.dart !');
    }

    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
        sendTimeout: const Duration(seconds: 5),
        contentType: 'application/json',
      ),
    );

    dio.interceptors.addAll([
      LogInterceptor(requestBody: true, responseBody: true),
      InterceptorsWrapper(
        onRequest: (options, handler) {
          return handler.next(options);
        },
      ),
    ]);
  }
}

/// Provider global Riverpod pour injecter le client Dio
final dioProvider = Provider<Dio>((ref) {
  final dio = DioClient().dio;
  return dio;
});
