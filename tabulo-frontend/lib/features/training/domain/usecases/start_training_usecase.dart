import '../entities/training.dart';
import '../entities/question.dart';
import '../repositories/training_repository.dart';

class StartTrainingUseCase {
  final TrainingRepository repository;

  StartTrainingUseCase(this.repository);

  Future<Training> call({
    required List<Question> questions,
    required List<int> selectedTables,
  }) async {
    final training = Training(
      questions: questions,
      operations: [],
      score: 0.0,
      finishedAt: null,
      selectedTables: selectedTables,
      currentIndex: 0,
      currentAnswer: '',
    );

    return await repository.save(training);
  }
}
