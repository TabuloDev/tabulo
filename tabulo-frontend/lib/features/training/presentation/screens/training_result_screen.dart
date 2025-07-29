import 'package:flutter/material.dart';
import '../../domain/entities/training.dart';

class TrainingResultScreen extends StatelessWidget {
  final Training training;

  const TrainingResultScreen({super.key, required this.training});

  @override
  Widget build(BuildContext context) {
    final score = training.score!;
    final message = score >= 8
        ? 'Excellent travail ! 👏'
        : score >= 5
        ? 'Bien joué, continue comme ça ! 💪'
        : 'Tu progresses, recommence pour t’améliorer ! 🚀';

    return Scaffold(
      appBar: AppBar(title: const Text('Résultat de l\'entraînement')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Score : ${score.toStringAsFixed(1)} / 10',
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Text(
              message,
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            const Text(
              'Détail des réponses :',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...training.operations.map(
              (op) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${op.expression} = ${op.userAnswer} → ${op.isCorrect ? '✔' : '✘'}',
                    style: TextStyle(
                      color: op.isCorrect ? Colors.green : Colors.red,
                      fontSize: 16,
                    ),
                  ),
                  if (!op.isCorrect && op.correctAnswer != null)
                    Text(
                      'Correction : ${op.expression} = ${op.correctAnswer}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Retour à l\'accueil'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
