import '../entities/training.dart';
import '../repositories/training_repository.dart';

class GetTrainingHistoryUseCase {
  final TrainingRepository repository;

  GetTrainingHistoryUseCase(this.repository);

  Future<List<Training>> call(String userId) {
    return repository.findAll(userId: userId);
  }
}
