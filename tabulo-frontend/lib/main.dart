// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tabulo/features/child/presentation/screens/child_home_screen.dart';
import 'package:tabulo/features/child/presentation/screens/training_detail_screen.dart';
import 'package:tabulo/features/training/application/providers/training_repository_provider.dart';
import 'package:tabulo/features/training/infrastructure/repositories/http_training_repository.dart';
import 'package:tabulo/core/dio_client.dart';
import 'package:tabulo/core/env.dart'; // ← pour accéder à baseUrl et tester sa validité

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  testBaseUrlAtImportTime();

  if (baseUrl.trim().isEmpty) {
    assert(false, '💥 baseUrl vide détecté au démarrage de l’application');
  }

  runApp(
    ProviderScope(
      overrides: [
        trainingRepositoryProvider.overrideWithValue(
          HttpTrainingRepository(dio: DioClient().dio),
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
      home: const ChildHomeScreen(),
      routes: {'/training-detail': (context) => const TrainingDetailScreen()},
    );
  }
}
