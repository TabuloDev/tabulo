import 'package:tabulo/features/training/domain/entities/training.dart';
import 'package:tabulo/features/training/domain/entities/operation.dart';
import 'package:tabulo/features/training/domain/repositories/training_repository.dart';

class SubmitAnswerUseCase {
  final TrainingRepository repository;

  SubmitAnswerUseCase(this.repository);

  Future<Training> call({
    required String trainingId,
    required String userAnswer,
  }) async {
    final training = await repository.findById(trainingId);

    if (training == null) {
      throw Exception('Training not found');
    }

    final currentQuestion = training.questions[training.currentIndex];
    final correctAnswer = (currentQuestion.operand1 * currentQuestion.operand2)
        .toString();
    final isCorrect = userAnswer.trim() == correctAnswer;

    final operation = Operation(
      expression: '${currentQuestion.operand1}×${currentQuestion.operand2}',
      userAnswer: userAnswer,
      isCorrect: isCorrect,
    );

    final nextIndex = training.currentIndex < training.questions.length - 1
        ? training.currentIndex + 1
        : training.currentIndex;

    final updated = training.copyWith(
      currentAnswer: userAnswer,
      operations: [...training.operations, operation],
      currentIndex: nextIndex,
    );

    await repository.save(updated);
    return updated;
  }
}
