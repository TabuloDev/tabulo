import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/training/presentation/screens/table_selection_screen.dart';
import 'features/training/application/providers/training_repository_provider.dart';
import 'features/training/infrastructure/repositories/in_memory_training_repository.dart';

void main() {
  runApp(
    ProviderScope(
      overrides: [
        trainingRepositoryProvider.overrideWithValue(
          inMemoryTrainingRepository,
        ),
      ],
      child: const TabuloApp(),
    ),
  );
}

class TabuloApp extends StatelessWidget {
  const TabuloApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tabulo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: const TableSelectionScreen(),
    );
  }
}
