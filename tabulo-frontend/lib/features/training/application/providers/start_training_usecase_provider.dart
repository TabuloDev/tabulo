// lib/features/training/application/providers/start_training_usecase_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/start_training_usecase.dart';
import '../../presentation/providers/training_repository_provider.dart';

final startTrainingUseCaseProvider = Provider((ref) {
  final repository = ref.watch(trainingRepositoryProvider);
  return StartTrainingUseCase(repository);
});
