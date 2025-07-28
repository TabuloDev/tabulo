import 'package:tabulo/features/training/domain/entities/training.dart';
import 'package:tabulo/features/training/domain/repositories/training_repository.dart';

class FinishTrainingUseCase {
  final TrainingRepository repository;

  FinishTrainingUseCase(this.repository);

  Future<Training> call(Training training) async {
    final total = training.operations.length;

    final score = total == 0
        ? 0.0
        : double.parse(
            ((training.operations.where((op) => op.isCorrect).length / total) *
                    10)
                .toStringAsFixed(1),
          );

    final finished = training.copyWith(
      score: score,
      finishedAt: DateTime.now(),
    );

    return await repository.save(finished);
  }
}
