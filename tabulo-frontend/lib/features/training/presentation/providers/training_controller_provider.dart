import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabulo/features/training/domain/entities/question.dart';
import 'package:tabulo/features/training/domain/entities/training.dart';
import 'package:tabulo/features/training/domain/usecases/start_training_usecase.dart';
import 'package:tabulo/features/training/domain/usecases/submit_answer_usecase.dart';
import 'package:tabulo/features/training/domain/usecases/finish_training_usecase.dart';
import 'package:tabulo/features/training/domain/repositories/training_repository.dart';

import 'package:tabulo/features/training/application/usecases/send_training_usecase.dart';
import 'package:tabulo/features/training/application/providers/start_training_usecase_provider.dart'
    as start_usecase;
import 'package:tabulo/features/training/application/providers/training_repository_provider.dart'
    as training_repo;
import 'package:tabulo/features/training/presentation/providers/submit_answer_usecase_provider.dart';
import 'package:tabulo/features/training/presentation/providers/send_training_usecase_provider.dart';

class TrainingController extends StateNotifier<Training?> {
  final StartTrainingUseCase startTrainingUseCase;
  final SubmitAnswerUseCase submitAnswerUseCase;
  final FinishTrainingUseCase finishTrainingUseCase;
  final SendTrainingUseCase sendTrainingUseCase;
  final TrainingRepository repository;

  TrainingController({
    required this.startTrainingUseCase,
    required this.submitAnswerUseCase,
    required this.finishTrainingUseCase,
    required this.sendTrainingUseCase,
    required this.repository,
  }) : super(null);

  Future<void> startTraining(List<int> selectedTables) async {
    final questions = generateQuestions(selectedTables);
    final training = await startTrainingUseCase(
      selectedTables: selectedTables,
      questions: questions,
    );
    state = training;
  }

  Future<void> submitAnswer(String userAnswer) async {
    final training = state;
    if (training == null) return;

    final isLastQuestion =
        training.currentIndex == training.questions.length - 1;

    final updated = await submitAnswerUseCase(
      trainingId: training.id,
      userAnswer: userAnswer,
    );

    if (isLastQuestion) {
      final finished = await finishTrainingUseCase(updated);
      state = finished;

      // 📨 Envoi vers le backend
      await sendTrainingUseCase(finished);
    } else {
      state = updated;
    }
  }

  Future<void> loadTrainingById(String id) async {
    final training = await repository.findById(id);
    if (training != null) {
      state = training;
    } else {
      throw Exception('Training not found with id $id');
    }
  }

  List<Question> generateQuestions(List<int> tables) {
    return tables
        .expand((table) => List.generate(10, (i) => Question(table, i + 1)))
        .toList();
  }
}

final trainingControllerProvider =
    StateNotifierProvider<TrainingController, Training?>((ref) {
  final repository = ref.read(training_repo.trainingRepositoryProvider);
  final startTrainingUseCase = ref.read(
    start_usecase.startTrainingUseCaseProvider,
  );
  final submitAnswerUseCase = ref.read(submitAnswerUseCaseProvider);
  final finishTrainingUseCase = FinishTrainingUseCase(repository);
  final sendTrainingUseCase = ref.read(sendTrainingUseCaseProvider);

  return TrainingController(
    repository: repository,
    startTrainingUseCase: startTrainingUseCase,
    submitAnswerUseCase: submitAnswerUseCase,
    finishTrainingUseCase: finishTrainingUseCase,
    sendTrainingUseCase: sendTrainingUseCase,
  );
});
