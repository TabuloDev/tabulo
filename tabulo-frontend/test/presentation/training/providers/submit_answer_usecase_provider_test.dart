import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tabulo/features/training/domain/entities/question.dart';
import 'package:tabulo/features/training/domain/entities/training.dart';
import 'package:tabulo/features/training/presentation/providers/submit_answer_usecase_provider.dart';
import 'package:tabulo/features/training/presentation/providers/training_repository_provider.dart';

void main() {
  test('le provider expose un SubmitAnswerUseCase fonctionnel', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final repository = container.read(trainingRepositoryProvider);

    final training = Training(
      id: 't123',
      questions: [Question(3, 4)],
      operations: [],
      selectedTables: [3, 4],
      currentAnswer: '',
      currentIndex: 0,
      score: null,
      finishedAt: null,
    );

    await repository.save(training);

    final submitAnswer = container.read(submitAnswerUseCaseProvider);

    final updated = await submitAnswer(
      trainingId: 't123',
      userAnswer: '12',
    );

    expect(updated.currentAnswer, '12');
    expect(updated.operations.length, 1);
    expect(updated.operations.first.userAnswer, '12');
    expect(updated.operations.first.isCorrect, true);
  });
}
