// lib/features/child/presentation/screens/training_history_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabulo/features/training/presentation/providers/training_history_controller_provider.dart';
import 'package:tabulo/features/training/presentation/widgets/training_history_list.dart';

class TrainingHistoryScreen extends ConsumerWidget {
  final String userId;

  const TrainingHistoryScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trainingsAsync = ref.watch(trainingHistoryControllerProvider(userId));

    return Scaffold(
      appBar: AppBar(title: const Text('Historique des entraînements')),
      body: trainingsAsync.when(
        data: (trainings) => TrainingHistoryList(
          trainings: trainings,
          onTap: (training) {
            Navigator.pushNamed(
              context,
              '/training-detail',
              arguments: training,
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text(
            'Erreur : $error',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }
}
