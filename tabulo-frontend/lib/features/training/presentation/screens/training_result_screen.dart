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
          mainAxisAlignment: MainAxisAlignment.center,
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
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // ou remplacer selon ta navigation
              },
              child: const Text('Retour à l\'accueil'),
            ),
          ],
        ),
      ),
    );
  }
}
