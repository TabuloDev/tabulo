import 'package:flutter/material.dart';
import 'package:tabulo/features/training/domain/entities/training.dart';
import 'package:intl/intl.dart';

class TrainingDetailScreen extends StatelessWidget {
  final Training? training;

  const TrainingDetailScreen({super.key, this.training});

  @override
  Widget build(BuildContext context) {
    final Training? data =
        training ?? ModalRoute.of(context)?.settings.arguments as Training?;

    if (data == null) {
      return const Scaffold(
        body: Center(child: Text('Aucun entraînement fourni.')),
      );
    }

    final String date = DateFormat(
      'EEEE d MMMM yyyy à HH:mm',
      'fr_FR',
    ).format(data.finishedAt!);

    return Scaffold(
      appBar: AppBar(title: const Text('Détail de l’entraînement')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Score : ${data.score!.toStringAsFixed(1)} / 10',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text('Terminé le $date'),
            const SizedBox(height: 24),
            const Text(
              'Opérations réalisées :',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: data.operations.length,
                itemBuilder: (context, index) {
                  final op = data.operations[index];
                  final correctText = op.isCorrect ? '✔️' : '❌';
                  final correction = !op.isCorrect && op.correctAnswer != null
                      ? ' (corrigé : ${op.correctAnswer})'
                      : '';
                  return ListTile(
                    title: Text(
                      '${op.expression} = ${op.userAnswer} $correctText$correction',
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
