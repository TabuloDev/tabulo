import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/selected_tables_provider.dart';
import 'training_screen.dart'; // <-- À adapter selon l'emplacement réel de l'écran d'entraînement

class TableSelectionScreen extends ConsumerWidget {
  const TableSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTables = ref.watch(selectedTablesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Choisis tes tables')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: List.generate(10, (index) {
                final number = index + 1;
                final isSelected = selectedTables.contains(number);

                return ElevatedButton(
                  onPressed: () {
                    ref.read(selectedTablesProvider.notifier).toggle(number);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
                    foregroundColor: isSelected ? Colors.white : Colors.black,
                  ),
                  child: Text(number.toString()),
                );
              }),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: selectedTables.isEmpty
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TrainingScreen(
                            selectedTables: selectedTables,
                          ),
                        ),
                      );
                    },
              child: const Text('Commencer'),
            ),
          ],
        ),
      ),
    );
  }
}
