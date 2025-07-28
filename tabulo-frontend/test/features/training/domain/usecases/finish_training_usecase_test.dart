import 'package:flutter_test/flutter_test.dart';
import 'package:tabulo/features/training/domain/entities/operation.dart';
import 'package:tabulo/features/training/domain/entities/training.dart';
import 'package:tabulo/features/training/domain/usecases/finish_training_usecase.dart';
import 'package:tabulo/features/training/domain/repositories/training_repository.dart';

// 🔧 Fake minimal pour satisfaire le use case
class FakeTrainingRepository implements TrainingRepository {
  @override
  Future<Training> save(Training training) async => training;

  @override
  Future<Training?> findById(String id) async => null;

  @override
  Future<void> deleteAll() async {}

  @override
  Future<List<Training>> findAll({required String userId}) async => [];

  Future<Training> update(Training training) async => training;
}

void main() {
  group('FinishTrainingUseCase', () {
    test('should calculate score correctly with 3/4 correct answers', () async {
      final training = Training(
        id: 't1',
        questions: [],
        operations: [
          Operation(expression: '2×3', userAnswer: '6', isCorrect: true),
          Operation(expression: '4×5', userAnswer: '20', isCorrect: true),
          Operation(expression: '6×7', userAnswer: '42', isCorrect: true),
          Operation(expression: '8×9', userAnswer: '70', isCorrect: false),
        ],
        score: 0.0,
        finishedAt: null,
        selectedTables: [2, 4, 6, 8],
        currentIndex: 0,
        currentAnswer: '',
      );

      final useCase = FinishTrainingUseCase(FakeTrainingRepository());
      final updated = await useCase(training);

      expect(updated.score, closeTo(7.5, 0.01));
      expect(updated.finishedAt, isNotNull);
    });

    test('should calculate 0 score when no answers are correct', () async {
      final training = Training(
        id: 't2',
        questions: [],
        operations: [
          Operation(expression: '1×1', userAnswer: '3', isCorrect: false),
          Operation(expression: '2×2', userAnswer: '5', isCorrect: false),
        ],
        score: 0.0,
        finishedAt: null,
        selectedTables: [1, 2],
        currentIndex: 0,
        currentAnswer: '',
      );

      final useCase = FinishTrainingUseCase(FakeTrainingRepository());
      final updated = await useCase(training);

      expect(updated.score, 0.0);
    });

    test('should calculate full score when all answers are correct', () async {
      final training = Training(
        id: 't3',
        questions: [],
        operations: [
          Operation(expression: '1×1', userAnswer: '1', isCorrect: true),
          Operation(expression: '2×2', userAnswer: '4', isCorrect: true),
        ],
        score: 0.0,
        finishedAt: null,
        selectedTables: [1, 2],
        currentIndex: 0,
        currentAnswer: '',
      );

      final useCase = FinishTrainingUseCase(FakeTrainingRepository());
      final updated = await useCase(training);

      expect(updated.score, 10.0);
    });
  });
}
