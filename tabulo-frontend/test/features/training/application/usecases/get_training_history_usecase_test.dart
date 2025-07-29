import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tabulo/features/training/domain/entities/training.dart';
import 'package:tabulo/features/training/domain/usecases/get_training_history_usecase.dart';
import 'package:tabulo/features/training/domain/repositories/training_repository.dart';

// ✅ Mock réel avec override de findAll
class MockTrainingRepository extends Mock implements TrainingRepository {
  @override
  Future<List<Training>> findAll({required String userId}) =>
      super.noSuchMethod(
        Invocation.method(#findAll, [], {#userId: userId}),
        returnValue: Future.value(<Training>[]),
        returnValueForMissingStub: Future.value(<Training>[]),
      );
}

void main() {
  group('GetTrainingHistoryUseCase', () {
    late MockTrainingRepository repository;
    late GetTrainingHistoryUseCase useCase;

    setUp(() {
      repository = MockTrainingRepository();
      useCase = GetTrainingHistoryUseCase(repository);
    });

    test('should return training list for given userId', () async {
      // Arrange
      const userId = 'abc123';
      final trainings = [
        Training(
          id: 't1',
          questions: [],
          operations: [],
          selectedTables: [2, 4],
          currentIndex: 0,
          currentAnswer: '',
          score: 8.5,
          finishedAt: DateTime.now(),
        ),
        Training(
          id: 't2',
          questions: [],
          operations: [],
          selectedTables: [3],
          currentIndex: 0,
          currentAnswer: '',
          score: 10.0,
          finishedAt: DateTime.now(),
        ),
      ];

      // ✅ Stub correct
      when(
        repository.findAll(userId: userId),
      ).thenAnswer((_) async => trainings);

      // Act
      final result = await useCase(userId);

      // Assert
      expect(result, trainings);
      verify(repository.findAll(userId: userId)).called(1);
    });
  });
}
