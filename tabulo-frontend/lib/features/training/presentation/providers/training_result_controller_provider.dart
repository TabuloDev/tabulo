import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabulo/features/training/domain/entities/training.dart';
import 'package:tabulo/features/training/application/usecases/send_training_usecase.dart';
import 'send_training_usecase_provider.dart';

final trainingResultControllerProvider =
    StateNotifierProvider<TrainingResultController, AsyncValue<void>>(
      (ref) => TrainingResultController(
        sendTrainingUseCase: ref.read(sendTrainingUseCaseProvider),
      ),
    );

class TrainingResultController extends StateNotifier<AsyncValue<void>> {
  final SendTrainingUseCase sendTrainingUseCase;

  TrainingResultController({required this.sendTrainingUseCase})
    : super(const AsyncData(null));

  Future<void> send(Training training) async {
    state = const AsyncLoading();
    try {
      await sendTrainingUseCase(training);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
