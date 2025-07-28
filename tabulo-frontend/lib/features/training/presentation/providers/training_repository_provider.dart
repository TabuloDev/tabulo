// lib/features/training/presentation/providers/training_repository_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/training_repository.dart';
import '../../infrastructure/repositories/in_memory_training_repository.dart';

/// ✅ Singleton global en dehors de Riverpod
final InMemoryTrainingRepository inMemoryTrainingRepository = InMemoryTrainingRepository();

/// ✅ Provider unique utilisé dans toute l'application
final trainingRepositoryProvider =
    Provider<TrainingRepository>((ref) => inMemoryTrainingRepository);
