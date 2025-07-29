import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabulo/features/training/domain/entities/training.dart';
import 'package:tabulo/features/training/domain/repositories/training_repository.dart';
import 'package:tabulo/features/training/domain/usecases/get_trainings_history_usecase.dart';
import 'package:tabulo/features/training/presentation/providers/training_history_controller_provider.dart';
import 'package:tabulo/features/training/presentation/providers/get_trainings_history_usecase_provider.dart';

class FakeGetTrainingsHistoryUseCase extends GetTrainingsHistoryUseCase {
  final List<Training> trainingsToReturn;

  FakeGetTrainingsHistoryUseCase({required this.trainingsToReturn})
    : super(_FakeRepository());

  @override
  Future<List<Training>> call({required String userId}) async {
    return trainingsToReturn;
  }
}

class _FakeRepository implements TrainingRepository {
  @override
  Future<void> deleteAll() async {}

  @override
  Future<Training?> findById(String id) async => null;

  @override
  Future<List<Training>> findAll({required String userId}) async =>
      throw UnimplementedError();

  @override
  Future<Training> save(Training training) async => throw UnimplementedError();
}

void main() {
  group('trainingHistoryControllerProvider', () {
    test('should return training list for a given userId', () async {
      const userId = 'user123';
      final trainingList = [
        Training(
          id: 't1',
          questions: [],
          operations: [],
          selectedTables: [2, 3],
          currentIndex: 0,
          currentAnswer: '',
          score: 9.5,
          finishedAt: DateTime.now(),
        ),
      ];

      final fakeUseCase = FakeGetTrainingsHistoryUseCase(
        trainingsToReturn: trainingList,
      );

      final container = ProviderContainer(
        overrides: [
          getTrainingsHistoryUseCaseProvider.overrideWithValue(fakeUseCase),
        ],
      );

      final result = await container.read(
        trainingHistoryControllerProvider(userId).future,
      );

      expect(result, trainingList);
    });
  });
}
