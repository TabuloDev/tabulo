import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabulo/features/training/domain/entities/training.dart';
import 'package:tabulo/features/training/presentation/providers/get_trainings_history_usecase_provider.dart';

/// Fournisseur qui expose la liste des entraînements terminés pour un utilisateur donné.
final trainingHistoryControllerProvider =
    FutureProvider.family<List<Training>, String>((ref, userId) async {
      final getHistory = ref.watch(getTrainingsHistoryUseCaseProvider);
      return getHistory(userId: userId);
    });
