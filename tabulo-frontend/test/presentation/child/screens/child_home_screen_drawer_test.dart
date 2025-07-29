import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabulo/features/child/presentation/screens/child_home_screen.dart';

void main() {
  testWidgets(
    'ChildHomeScreen should show drawer with Historique des entraînements',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: ChildHomeScreen())),
      );

      expect(find.byIcon(Icons.menu), findsOneWidget);
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();
      expect(find.text('Historique des entraînements'), findsOneWidget);
    },
  );
}
