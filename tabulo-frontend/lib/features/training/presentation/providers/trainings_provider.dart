import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabulo/core/dio_client.dart';
import 'package:tabulo/features/training/domain/entities/training.dart';

/// Provider asynchrone qui récupère les entraînements d’un utilisateur donné.
final trainingsProvider = FutureProvider.family<List<Training>, String>((
  ref,
  userId,
) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.get(
    '/api/trainings',
    queryParameters: {'userId': userId},
  );

  final data = response.data as List<dynamic>;
  return data.map((json) => Training.fromJson(json)).toList();
});
