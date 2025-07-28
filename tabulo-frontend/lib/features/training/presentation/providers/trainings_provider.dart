// lib/features/training/presentation/providers/trainings_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabulo/core/dio_client.dart';
import 'package:tabulo/features/training/domain/entities/training.dart';
import 'package:tabulo/features/training/infrastructure/dto/training_dto.dart';

/// Provider asynchrone qui récupère les entraînements d’un utilisateur donné.
final trainingsProvider = FutureProvider.family<List<Training>, String>((
  ref,
  userId,
) async {
  final dio = ref.watch(dioProvider);

  try {
    final response = await dio.get(
      '/api/trainings',
      queryParameters: {'userId': userId},
    );

    final data = response.data as List<dynamic>;

    final trainings = data.map((json) {
      final dto = TrainingDto.fromJson(json);
      return dto.toDomain();
    }).toList();

    return trainings;
  } catch (_) {
    return [];
  }
});
