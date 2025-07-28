import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tabulo/features/training/domain/entities/training.dart';
import 'package:tabulo/features/training/domain/repositories/training_repository.dart';
import 'package:tabulo/features/training/domain/usecases/get_trainings_history_usecase.dart';
import 'package:tabulo/features/training/presentation/providers/training_history_controller_provider.dart';
import 'package:tabulo/features/training/presentation/providers/get_trainings_history_usecase_provider.dart';

class FakeTrainingRepository implements TrainingRepository {
  final List<Training> trainings;

  FakeTrainingRepository(this.trainings);

  @override
  Future<List<Training>> findAll({required String userId}) async {
    return trainings.where((t) => t.id.startsWith(userId)).toList();
  }

  @override
  Future<Training?> findById(String id) async {
    try {
      return trainings.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Training> save(Training training) async {
    trainings.add(training);
    return training;
  }

  @override
  Future<void> deleteAll() async {
    trainings.clear();
  }
}

void main() {
  group('trainingHistoryControllerProvider', () {
    test('should load trainings history for a given user', () async {
      // Arrange
      final training1 = Training(
        id: 'user1-training1',
        selectedTables: [2, 3],
        questions: [],
        currentIndex: 0,
        currentAnswer: '',
        finishedAt: DateTime.now(),
        score: 8.5,
        operations: [],
      );

      final training2 = Training(
        id: 'user1-training2',
        selectedTables: [4, 5],
        questions: [],
        currentIndex: 0,
        currentAnswer: '',
        finishedAt: DateTime.now(),
        score: 9.0,
        operations: [],
      );

      final fakeRepository = FakeTrainingRepository([training1, training2]);
      final fakeUseCase = GetTrainingsHistoryUseCase(fakeRepository);

      final container = ProviderContainer(
        overrides: [
          getTrainingsHistoryUseCaseProvider.overrideWithValue(fakeUseCase),
        ],
      );

      addTearDown(container.dispose);

      // Act
      await container.read(trainingHistoryControllerProvider('user1').future);
      final result = container.read(trainingHistoryControllerProvider('user1'));

      // Assert
      expect(result, isA<AsyncData<List<Training>>>());
      expect(result.value, hasLength(2));
      expect(result.value!.every((t) => t.id.startsWith('user1')), isTrue);
    });
  });
}
