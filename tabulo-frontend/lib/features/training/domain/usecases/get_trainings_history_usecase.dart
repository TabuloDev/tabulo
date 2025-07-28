import 'package:tabulo/features/training/domain/entities/training.dart';
import 'package:tabulo/features/training/domain/repositories/training_repository.dart';

class GetTrainingsHistoryUseCase {
  final TrainingRepository repository;

  GetTrainingsHistoryUseCase(this.repository);

  Future<List<Training>> call({required String userId}) {
    return repository.findAll(userId: userId);
  }
}
