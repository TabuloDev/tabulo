import 'package:flutter_test/flutter_test.dart';
import 'package:tabulo/features/training/domain/entities/training.dart';
import 'package:tabulo/features/training/domain/repositories/training_repository.dart';
import 'package:tabulo/features/training/domain/usecases/get_trainings_history_usecase.dart';

class FakeTrainingRepository implements TrainingRepository {
  final List<Training> trainings;

  FakeTrainingRepository(this.trainings);

  @override
  Future<List<Training>> findAll({required String userId}) async {
    return trainings.where((t) => t.id.startsWith(userId)).toList();
  }

  @override
  Future<Training?> findById(String id) async => null;

  @override
  Future<Training> save(Training training) async {
    trainings.add(training);
    return training;
  }

  @override
  Future<void> deleteAll() async {}
}

void main() {
  group('GetTrainingsHistoryUseCase', () {
    test('should return trainings for a given userId', () async {
      final fakeTrainings = [
        Training(
          id: 'u1-training1',
          questions: [],
          operations: [],
          score: 8.5,
          finishedAt: DateTime.now(),
          selectedTables: [2, 3],
          currentIndex: 0,
          currentAnswer: '',
        ),
        Training(
          id: 'u2-training2',
          questions: [],
          operations: [],
          score: 10.0,
          finishedAt: DateTime.now(),
          selectedTables: [7, 8],
          currentIndex: 0,
          currentAnswer: '',
        ),
      ];

      final repository = FakeTrainingRepository(fakeTrainings);
      final useCase = GetTrainingsHistoryUseCase(repository);

      final result = await useCase(userId: 'u1');

      expect(result.length, 1);
      expect(result.first.id, 'u1-training1');
    });
  });
}
