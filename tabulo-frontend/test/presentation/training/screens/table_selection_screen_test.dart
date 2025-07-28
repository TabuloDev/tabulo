// test/presentation/training/screens/table_selection_screen_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tabulo/features/training/presentation/screens/table_selection_screen.dart';

void main() {
  testWidgets('Affiche les boutons 1 à 10', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: TableSelectionScreen()),
      ),
    );

    for (int i = 1; i <= 10; i++) {
      expect(find.text(i.toString()), findsOneWidget);
    }
  });

  testWidgets('Sélectionne et désélectionne un bouton de table', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: TableSelectionScreen()),
      ),
    );

    final table3 = find.text('3');
    expect(table3, findsOneWidget);

    await tester.tap(table3);
    await tester.pump();

    // On s’attend à ce que le bouton soit maintenant sélectionné.
    // Tu pourras ajuster ce test pour vérifier le style (ex: couleur de fond).

    await tester.tap(table3);
    await tester.pump();

    // Le bouton devrait maintenant être désélectionné.
  });

  testWidgets('Bouton "Commencer" activé seulement si une table est sélectionnée', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: TableSelectionScreen()),
      ),
    );

    final startButton = find.widgetWithText(ElevatedButton, 'Commencer');
    expect(startButton, findsOneWidget);

    // Initialement désactivé
    final ElevatedButton buttonWidget = tester.widget(startButton);
    expect(buttonWidget.onPressed, isNull);

    // Sélectionnons la table 5
    await tester.tap(find.text('5'));
    await tester.pump();

    // Le bouton doit maintenant être activé
    final ElevatedButton updatedButton = tester.widget(startButton);
    expect(updatedButton.onPressed, isNotNull);
  });

  testWidgets('Navigue vers TrainingScreen avec les tables sélectionnées', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: TableSelectionScreen()),
      ),
    );

    await tester.tap(find.text('2'));
    await tester.tap(find.text('3'));
    await tester.pump();

    await tester.tap(find.text('Commencer'));
    await tester.pumpAndSettle();

    expect(find.text('Tables sélectionnées : 2, 3'), findsOneWidget);
  });
}
