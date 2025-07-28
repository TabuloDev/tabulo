import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tabulo/features/training/presentation/providers/selected_tables_provider.dart';

void main() {
  group('selectedTablesProvider', () {
    test('should start with an empty list', () {
      final container = ProviderContainer();
      final tables = container.read(selectedTablesProvider);

      expect(tables, isEmpty);
    });

    test('should add a table when toggled from unselected', () {
      final container = ProviderContainer();
      final notifier = container.read(selectedTablesProvider.notifier);

      notifier.toggle(4);

      final tables = container.read(selectedTablesProvider);
      expect(tables, contains(4));
      expect(tables.length, 1);
    });

    test('should remove a table when toggled from selected', () {
      final container = ProviderContainer();
      final notifier = container.read(selectedTablesProvider.notifier);

      notifier.toggle(4); // select
      notifier.toggle(4); // unselect

      final tables = container.read(selectedTablesProvider);
      expect(tables, isNot(contains(4)));
      expect(tables.length, 0);
    });

    test('should support multiple table selections', () {
      final container = ProviderContainer();
      final notifier = container.read(selectedTablesProvider.notifier);

      notifier.toggle(2);
      notifier.toggle(3);
      notifier.toggle(5);

      final tables = container.read(selectedTablesProvider);
      expect(tables, containsAll([2, 3, 5]));
      expect(tables.length, 3);
    });
  });
}
