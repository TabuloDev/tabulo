import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabulo/features/child/presentation/screens/child_home_screen.dart';

void main() {
  testWidgets(
    'Tapping on Historique in Drawer navigates to TrainingHistoryScreen',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: ChildHomeScreen())),
      );

      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Historique des entraînements'));
      await tester.pumpAndSettle();

      expect(find.text('Historique'), findsOneWidget);
      expect(find.byType(ListTile), findsWidgets);
    },
  );
}
