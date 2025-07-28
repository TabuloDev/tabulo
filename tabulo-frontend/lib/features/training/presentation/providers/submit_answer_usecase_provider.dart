import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tabulo/features/training/domain/usecases/submit_answer_usecase.dart';
import 'package:tabulo/features/training/presentation/providers/training_repository_provider.dart';

final submitAnswerUseCaseProvider = Provider<SubmitAnswerUseCase>((ref) {
  final repository = ref.read(trainingRepositoryProvider);
  return SubmitAnswerUseCase(repository);
});
