import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();

  factory DioClient() => _instance;

  late final Dio dio;

  DioClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'http://localhost:5000/api', // à adapter selon l'environnement
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
          // TODO: Ajouter le token JWT ici lorsqu'il sera disponible
          return handler.next(options);
        },
      ),
    ]);
  }
}

/// Provider global Riverpod pour injecter le client Dio
final dioProvider = Provider<Dio>((ref) {
  return DioClient().dio;
});
