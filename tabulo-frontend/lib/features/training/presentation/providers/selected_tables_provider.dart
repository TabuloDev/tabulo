import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedTablesProvider =
    StateNotifierProvider<SelectedTablesNotifier, List<int>>(
  (ref) => SelectedTablesNotifier(),
);

class SelectedTablesNotifier extends StateNotifier<List<int>> {
  SelectedTablesNotifier() : super([]);

  void toggle(int table) {
    if (state.contains(table)) {
      state = [...state]..remove(table);
    } else {
      state = [...state, table];
    }
  }

  void reset() {
    state = [];
  }
}
