import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabulo/features/training/domain/usecases/get_trainings_history_usecase.dart';
import 'package:tabulo/features/training/presentation/providers/training_repository_provider.dart';

final getTrainingsHistoryUseCaseProvider = Provider<GetTrainingsHistoryUseCase>(
  (ref) {
    final repository = ref.watch(trainingRepositoryProvider);
    return GetTrainingsHistoryUseCase(repository);
  },
);
