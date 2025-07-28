// lib/features/training/application/providers/training_repository_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/training_repository.dart';
import '../../infrastructure/repositories/in_memory_training_repository.dart';

final trainingRepositoryProvider = Provider<TrainingRepository>((ref) {
  return InMemoryTrainingRepository();
});
