// test/features/training/domain/usecases/submit_answer_usecase_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:tabulo/features/training/domain/entities/question.dart';
import 'package:tabulo/features/training/domain/entities/training.dart';
import 'package:tabulo/features/training/domain/repositories/training_repository.dart';
import 'package:tabulo/features/training/domain/usecases/submit_answer_usecase.dart';

class FakeTrainingRepository implements TrainingRepository {
  final Map<String, Training> _storage = {};

  Future<Training> getById(String id) async {
    final training = _storage[id];
    if (training == null) throw Exception('Training not found');
    return training;
  }

  Future<Training> update(Training training) async {
    _storage[training.id] = training;
    return training;
  }

  @override
  Future<Training?> findById(String id) async => _storage[id];

  @override
  Future<Training> save(Training training) async {
    _storage[training.id] = training;
    return training;
  }

  @override
  Future<void> deleteAll() async => _storage.clear();

  @override
  Future<List<Training>> findAll({required String userId}) async =>
      _storage.values.toList();
}

void main() {
  group('SubmitAnswerUseCase', () {
    late SubmitAnswerUseCase useCase;
    late FakeTrainingRepository repository;
    late Training training;

    setUp(() async {
      repository = FakeTrainingRepository();
      useCase = SubmitAnswerUseCase(repository);

      training = Training(
        id: 'training1',
        questions: [Question(6, 4), Question(3, 5)],
        operations: [],
        selectedTables: [3, 4, 5, 6],
        currentAnswer: '',
        currentIndex: 0,
        score: null,
        finishedAt: null,
      );

      await repository.save(training);
    });

    test('soumet une réponse correcte', () async {
      await useCase(trainingId: 'training1', userAnswer: '24');
      final updated = await repository.getById('training1');

      expect(updated.operations.first.userAnswer, '24');
      expect(updated.operations.first.isCorrect, true);
    });

    test('soumet une réponse incorrecte', () async {
      await useCase(trainingId: 'training1', userAnswer: '25');
      final updated = await repository.getById('training1');

      expect(updated.operations.first.userAnswer, '25');
      expect(updated.operations.first.isCorrect, false);
    });

    test('soumet plusieurs réponses consécutives', () async {
      await useCase(trainingId: 'training1', userAnswer: '24');
      await useCase(trainingId: 'training1', userAnswer: '15');

      final updated = await repository.getById('training1');

      expect(updated.operations[0].userAnswer, '24');
      expect(updated.operations[0].isCorrect, true);
      expect(updated.operations[1].userAnswer, '15');
      expect(updated.operations[1].isCorrect, true);
    });

    test('échoue si l\'entraînement est introuvable', () async {
      expect(
        () => useCase(trainingId: 'inexistant', userAnswer: '12'),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Training not found'),
          ),
        ),
      );
    });
  });
}
