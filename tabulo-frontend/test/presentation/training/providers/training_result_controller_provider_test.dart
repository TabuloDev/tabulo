import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:tabulo/features/training/domain/entities/training.dart';
import 'package:tabulo/features/training/application/usecases/send_training_usecase.dart';
import 'package:tabulo/features/training/presentation/providers/training_result_controller_provider.dart';

// ✅ Redéfinition explicite de call
class MockSendTrainingUseCase extends Mock implements SendTrainingUseCase {
  @override
  Future<bool> call(Training training) => super.noSuchMethod(
    Invocation.method(#call, [training]),
    returnValue: Future.value(true),
    returnValueForMissingStub: Future.value(true),
  );
}

void main() {
  group('trainingResultControllerProvider', () {
    test('should emit AsyncData when training is sent successfully', () async {
      final mockUseCase = MockSendTrainingUseCase();
      final training = Training(
        id: '123',
        questions: [],
        operations: [],
        selectedTables: [3, 4],
        currentIndex: 0,
        currentAnswer: '',
        score: 9.0,
        finishedAt: DateTime.now(),
      );

      final container = ProviderContainer(
        overrides: [
          trainingResultControllerProvider.overrideWith(
            (ref) => TrainingResultController(sendTrainingUseCase: mockUseCase),
          ),
        ],
      );

      final controller = container.read(
        trainingResultControllerProvider.notifier,
      );

      await controller.send(training);

      expect(
        container.read(trainingResultControllerProvider),
        isA<AsyncData<void>>(),
      );
      verify(mockUseCase.call(training)).called(1);
    });
  });
}
