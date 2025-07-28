import 'package:flutter_test/flutter_test.dart';
import 'package:tabulo/features/training/domain/entities/question.dart';
import 'package:tabulo/features/training/domain/repositories/training_repository.dart';
import 'package:tabulo/features/training/domain/usecases/start_training_usecase.dart';
import 'package:tabulo/features/training/infrastructure/repositories/in_memory_training_repository.dart';

void main() {
  group('StartTrainingUseCase', () {
    late TrainingRepository repository;
    late StartTrainingUseCase useCase;

    setUp(() {
      repository = InMemoryTrainingRepository();
      useCase = StartTrainingUseCase(repository);
    });

    test(
      'should create and store a training with the given questions',
      () async {
        final questions = [Question(2, 3), Question(4, 5)];
        final selectedTables = [2, 3, 4, 5];

        final training = await useCase(questions: questions, selectedTables: selectedTables);

        expect(training.questions, questions);
        expect(training.selectedTables, selectedTables);
        expect(training.finishedAt, isNull);
        expect(training.operations, isEmpty);
        expect(training.score, 0.0);
        expect(training.currentIndex, 0);
        expect(training.currentAnswer, '');
      },
    );
  });
}
