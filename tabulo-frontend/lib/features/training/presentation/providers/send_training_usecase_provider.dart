// lib/features/training/presentation/providers/send_training_usecase_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabulo/features/training/application/usecases/send_training_usecase.dart';
import 'package:tabulo/core/dio_client.dart'; // ✅ importer dioProvider

final sendTrainingUseCaseProvider = Provider<SendTrainingUseCase>((ref) {
  final dio = ref.watch(dioProvider); // ✅ utiliser l'instance configurée
  return SendTrainingUseCase(dio);
});
