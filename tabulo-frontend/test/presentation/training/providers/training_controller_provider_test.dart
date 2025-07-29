import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tabulo/features/training/domain/entities/training.dart';
import 'package:tabulo/features/training/domain/entities/question.dart';
import 'package:tabulo/features/training/domain/repositories/training_repository.dart';
import 'package:tabulo/features/training/domain/usecases/start_training_usecase.dart';
import 'package:tabulo/features/training/domain/usecases/submit_answer_usecase.dart';
import 'package:tabulo/features/training/domain/usecases/finish_training_usecase.dart';
import 'package:tabulo/features/training/presentation/providers/training_controller_provider.dart';
import 'package:tabulo/features/training/application/usecases/send_training_usecase.dart';
import '../../../mocks.mocks.dart'; // ✅ pour MockDio

void main() {
  group('trainingControllerProvider', () {
    late ProviderContainer container;
    late TrainingController controller;
    late FakeTrainingRepository repository;
    const trainingId = 'training-1';

    setUp(() async {
      repository = FakeTrainingRepository();

      final training = Training(
        id: trainingId,
        questions: List.generate(10, (i) => Question(3, i + 1)),
        operations: [],
        selectedTables: [3],
        currentAnswer: '',
        currentIndex: 0,
        score: null,
        finishedAt: null,
      );

      await repository.save(training);

      final startTrainingUseCase = StartTrainingUseCase(repository);
      final submitAnswerUseCase = SubmitAnswerUseCase(repository);
      final finishTrainingUseCase = FinishTrainingUseCase(repository);
      final sendTrainingUseCase = SendTrainingUseCase(MockDio()); // ✅

      container = ProviderContainer(
        overrides: [
          trainingControllerProvider.overrideWith((ref) {
            final controller = TrainingController(
              repository: repository,
              startTrainingUseCase: startTrainingUseCase,
              submitAnswerUseCase: submitAnswerUseCase,
              finishTrainingUseCase: finishTrainingUseCase,
              sendTrainingUseCase: sendTrainingUseCase,
            );
            controller.state = training;
            return controller;
          }),
        ],
      );

      controller = container.read(trainingControllerProvider.notifier);
    });

    tearDown(() {
      container.dispose();
    });

    test('should update training state after submitting answer', () async {
      final question = container.read(trainingControllerProvider)!.questions[0];
      final correctAnswer = (question.operand1 * question.operand2).toString();

      await controller.submitAnswer(correctAnswer);

      final updated = container.read(trainingControllerProvider)!;
      expect(updated.operations.length, 1);
      expect(updated.operations[0].userAnswer, correctAnswer);
      expect(updated.operations[0].isCorrect, isTrue);
    });

    test('should progress to next question after answering', () async {
      final question = container.read(trainingControllerProvider)!.questions[0];
      final correctAnswer = (question.operand1 * question.operand2).toString();

      await controller.submitAnswer(correctAnswer);

      final updated = container.read(trainingControllerProvider)!;
      expect(updated.currentIndex, 1);
    });

    test('should store all answered questions', () async {
      for (int i = 0; i < 10; i++) {
        final question = container
            .read(trainingControllerProvider)!
            .questions[i];
        final correctAnswer = (question.operand1 * question.operand2)
            .toString();
        await controller.submitAnswer(correctAnswer);
      }

      final finalTraining = container.read(trainingControllerProvider)!;
      expect(finalTraining.operations.length, 10);
      expect(
        finalTraining.operations.every((op) => op.isCorrect == true),
        isTrue,
      );
    });

    test('should calculate score at the end of training', () async {
      for (int i = 0; i < 10; i++) {
        final question = container
            .read(trainingControllerProvider)!
            .questions[i];
        final answer = (question.operand1 * question.operand2).toString();
        await controller.submitAnswer(answer);
      }

      await container.pumpUntil(
        () => container.read(trainingControllerProvider)?.score != null,
        timeout: const Duration(seconds: 1),
      );

      final finalTraining = container.read(trainingControllerProvider)!;

      expect(finalTraining.score, isNotNull);
    });
  });
}

// Extension pour pumpUntil
extension PumpUntil on ProviderContainer {
  Future<void> pumpUntil(
    bool Function() condition, {
    Duration timeout = const Duration(seconds: 1),
    Duration step = const Duration(milliseconds: 10),
  }) async {
    final deadline = DateTime.now().add(timeout);
    while (!condition()) {
      if (DateTime.now().isAfter(deadline)) {
        throw Exception('Condition not met within timeout');
      }
      await Future.delayed(step);
    }
  }
}

// Implémentation du FakeTrainingRepository utilisée dans les tests
class FakeTrainingRepository implements TrainingRepository {
  final Map<String, Training> _storage = {};
  int _counter = 0;

  @override
  Future<Training> save(Training training) async {
    final id = training.id.isEmpty ? 't${_counter++}' : training.id;
    final saved = training.copyWith(id: id);
    _storage[id] = saved;
    return saved;
  }

  @override
  Future<Training?> findById(String id) async => _storage[id];

  @override
  Future<void> deleteAll() async => _storage.clear();

  @override
  Future<List<Training>> findAll({required String userId}) async =>
      _storage.values.toList();

  Future<Training> getById(String id) async {
    final training = _storage[id];
    if (training == null) throw Exception('Training not found');
    return training;
  }

  Future<Training> update(Training training) async {
    if (!_storage.containsKey(training.id)) {
      throw Exception('Training not found');
    }
    _storage[training.id] = training;
    return training;
  }
}
