import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tabulo/features/training/domain/entities/training.dart';

class TrainingHistoryList extends StatelessWidget {
  final List<Training> trainings;
  final void Function(Training training) onTap;

  const TrainingHistoryList({
    super.key,
    required this.trainings,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (trainings.isEmpty) {
      return const Center(child: Text("Aucun entraînement trouvé."));
    }

    return ListView.builder(
      itemCount: trainings.length,
      itemBuilder: (context, index) {
        final training = trainings[index];
        final date = DateFormat(
          'dd/MM/yyyy – HH:mm',
        ).format(training.finishedAt!);
        final score = training.score!.toStringAsFixed(1);

        return ListTile(
          title: Text('Score : $score / 10'),
          subtitle: Text('Terminé le $date'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () => onTap(training),
        );
      },
    );
  }
}
