import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tabulo/features/training/domain/entities/training.dart';
import 'package:tabulo/features/training/presentation/providers/training_repository_provider.dart';

void main() {
  test(
    'le provider expose un TrainingRepository fonctionnel (inMemory)',
    () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final repository = container.read(trainingRepositoryProvider);

      final training = Training(
        id: 'test123',
        questions: [],
        operations: [],
        selectedTables: [],
        currentAnswer: '',
        currentIndex: 0,
        score: null,
        finishedAt: null,
      );

      await repository.save(training);
      final found = await repository.findById('test123');

      expect(found, isNotNull);
      expect(found!.id, 'test123');
    },
  );
}
