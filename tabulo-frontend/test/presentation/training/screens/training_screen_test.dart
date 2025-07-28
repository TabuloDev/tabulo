// test/presentation/training/screens/training_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabulo/features/training/presentation/screens/training_screen.dart';
import 'package:tabulo/features/training/presentation/screens/training_result_screen.dart';
import 'package:tabulo/features/training/presentation/providers/training_controller_provider.dart';
import 'package:tabulo/features/training/infrastructure/repositories/in_memory_training_repository.dart';
import 'package:tabulo/features/training/domain/usecases/start_training_usecase.dart';
import 'package:tabulo/features/training/domain/usecases/submit_answer_usecase.dart';
import 'package:tabulo/features/training/domain/usecases/finish_training_usecase.dart';
import 'package:tabulo/features/training/domain/entities/question.dart';

class TestTrainingController extends TrainingController {
  TestTrainingController({
    required super.repository,
    required super.startTrainingUseCase,
    required super.submitAnswerUseCase,
    required super.finishTrainingUseCase,
  });

  @override
  List<Question> generateQuestions(List<int> tables) {
    // Une seule question : 3 x 4 = 12
    return [Question(3, 4)];
  }
}

void main() {
  testWidgets('Terminer un entraînement redirige vers l\'écran de résultat', (tester) async {
    final repository = InMemoryTrainingRepository();

    final controller = TestTrainingController(
      repository: repository,
      startTrainingUseCase: StartTrainingUseCase(repository),
      submitAnswerUseCase: SubmitAnswerUseCase(repository),
      finishTrainingUseCase: FinishTrainingUseCase(repository),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          trainingControllerProvider.overrideWith((ref) => controller),
        ],
        child: const MaterialApp(home: TrainingScreen(selectedTables: [3])),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byKey(const Key('questionText')), findsOneWidget);
    await tester.enterText(find.byType(TextField), '12'); // bonne réponse à 3x4
    await tester.tap(find.text('Valider'));

    await tester.pumpAndSettle();

    // Cette fois, on devrait bien être redirigé
    expect(find.byType(TrainingResultScreen), findsOneWidget);
  });
}
