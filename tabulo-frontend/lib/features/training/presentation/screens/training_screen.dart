import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/training_controller_provider.dart';
import 'training_result_screen.dart';

class TrainingScreen extends ConsumerStatefulWidget {
  final List<int> selectedTables;

  const TrainingScreen({super.key, required this.selectedTables});

  @override
  ConsumerState<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends ConsumerState<TrainingScreen> {
  final TextEditingController _controller = TextEditingController();
  String? _feedbackMessage;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!Platform.environment.containsKey('FLUTTER_TEST')) {
        ref
            .read(trainingControllerProvider.notifier)
            .startTraining(widget.selectedTables);
      }
    });
  }

  void _submit() async {
    final training = ref.read(trainingControllerProvider);
    if (training == null || training.finishedAt != null) {
      return;
    }

    final currentQuestion = training.questions[training.currentIndex];
    final userAnswer = _controller.text.trim();

    if (userAnswer.isEmpty) {
      return;
    }

    await ref
        .read(trainingControllerProvider.notifier)
        .submitAnswer(userAnswer);

    final updatedTraining = ref.read(trainingControllerProvider);
    if (updatedTraining == null) return;

    if (updatedTraining.finishedAt != null) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => TrainingResultScreen(training: updatedTraining),
          ),
        );
      }
    } else {
      final correctAnswer =
          (currentQuestion.operand1 * currentQuestion.operand2).toString();
      final wasCorrect = userAnswer == correctAnswer;

      setState(() {
        _feedbackMessage = wasCorrect
            ? 'Bonne réponse !'
            : 'Faux ! (${currentQuestion.operand1} × ${currentQuestion.operand2} = $correctAnswer)';
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final training = ref.watch(trainingControllerProvider);

    if (training == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Entraînement')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Tables sélectionnées : ${training.selectedTables.join(', ')}',
              key: const Key('selectedTablesText'),
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            Text(
              '${training.questions[training.currentIndex].operand1} × ${training.questions[training.currentIndex].operand2}',
              key: const Key('questionText'),
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 64.0),
              child: TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Votre réponse',
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _submit, child: const Text('Valider')),
            const SizedBox(height: 16),
            if (_feedbackMessage != null)
              Text(
                _feedbackMessage!,
                key: const Key('feedbackMessage'),
                style: TextStyle(
                  color: _feedbackMessage!.startsWith('Bonne')
                      ? Colors.green
                      : Colors.red,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
