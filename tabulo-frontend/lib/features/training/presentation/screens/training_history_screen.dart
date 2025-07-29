import 'package:flutter/material.dart';
import 'package:tabulo/features/training/domain/entities/training.dart';
import 'package:tabulo/features/training/presentation/widgets/training_history_list.dart';

class TrainingHistoryScreen extends StatelessWidget {
  const TrainingHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔧 Temporaire : fausse liste pour faire fonctionner l’écran
    final fakeTrainings = [
      Training(
        id: '1',
        selectedTables: [2, 3],
        questions: [],
        operations: [],
        score: 7.5,
        currentIndex: 0,
        currentAnswer: '',
        finishedAt: DateTime.now(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Historique')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TrainingHistoryList(
          trainings: fakeTrainings,
          onTap: (training) {
            // Rien pour le moment
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('ID sélectionné : ${training.id}')),
            );
          },
        ),
      ),
    );
  }
}
