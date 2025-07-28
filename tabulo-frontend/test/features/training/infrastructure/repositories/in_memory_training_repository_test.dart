import 'package:flutter_test/flutter_test.dart';
import 'package:tabulo/features/training/domain/entities/question.dart';
import 'package:tabulo/features/training/domain/entities/training.dart';
import 'package:tabulo/features/training/infrastructure/repositories/in_memory_training_repository.dart';

void main() {
  group('InMemoryTrainingRepository', () {
    late InMemoryTrainingRepository repository;

    setUp(() {
      repository = InMemoryTrainingRepository();
    });

    test('should save and retrieve a training', () async {
      final training = Training(
        id: 't1',
        questions: [],
        operations: [],
        score: 0.0,
        finishedAt: null,
        selectedTables: [],
        currentIndex: 0,
        currentAnswer: '',
      );

      final saved = await repository.save(training);

      final found = await repository.findById(saved.id);

      expect(found, isNotNull);
      expect(found!.id, saved.id);
    });

    test('should overwrite an existing training with same id', () async {
      final training = Training(
        id: 't2',
        questions: [],
        operations: [],
        score: 0.0,
        finishedAt: null,
        selectedTables: [],
        currentIndex: 0,
        currentAnswer: '',
      );

      final saved = await repository.save(training);

      final modified = saved.copyWith(score: 8.5);
      await repository.save(modified);

      final found = await repository.findById(saved.id);
      expect(found!.score, 8.5);
    });

    test('should clear all trainings', () async {
      final t1 = await repository.save(Training(
        id: 't3',
        questions: [],
        operations: [],
        score: 0.0,
        finishedAt: null,
        selectedTables: [],
        currentIndex: 0,
        currentAnswer: '',
      ));

      final t2 = await repository.save(Training(
        id: 't4',
        questions: [],
        operations: [],
        score: 0.0,
        finishedAt: null,
        selectedTables: [],
        currentIndex: 0,
        currentAnswer: '',
      ));

      await repository.deleteAll();

      final f1 = await repository.findById(t1.id);
      final f2 = await repository.findById(t2.id);

      expect(f1, isNull);
      expect(f2, isNull);
    });

    test('should retrieve training by explicit ID', () async {
      final training = Training(
        id: 'training_123',
        questions: [Question(5, 6), Question(2, 3)],
        operations: [],
        score: 0.0,
        finishedAt: null,
        selectedTables: [2, 3, 5, 6],
        currentIndex: 0,
        currentAnswer: '',
      );

      await repository.save(training);
      final found = await repository.findById('training_123');

      expect(found, isNotNull);
      expect(found!.id, equals('training_123'));
      expect(found.questions.length, equals(2));
    });
  });
}
