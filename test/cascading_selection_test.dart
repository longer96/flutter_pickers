import 'package:flutter_pickers/src/cascading_picker/cascading_selection.dart';
import 'package:flutter_pickers/src/cascading_picker/nested_map_adapter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Linked Picker resets downstream columns through its data adapter', () {
    final selection = CascadingSelectionModule(
      adapter: NestedMapAdapter(
        data: const {
          'A': {
            'A1': ['x', 'y'],
            'A2': ['z'],
          },
          'B': {
            'B1': ['q'],
          },
        },
        columnCount: 3,
      ),
      initial: const ['A', 'A1', 'y'],
    );

    final state = selection.select(0, 1);

    expect(state.selection, ['B', 'B1', 'q']);
    expect(state.positions, [1, 0, 0]);
    expect(state.column(1), ['B1']);
    expect(state.column(2), ['q']);
  });

  test('Linked Picker fills columns after an early terminal branch', () {
    final selection = CascadingSelectionModule(
      adapter: NestedMapAdapter(
        data: const {
          'short': 'value',
          'deep': {
            'child': ['leaf'],
          },
        },
        columnCount: 3,
      ),
      initial: const ['short'],
    );

    expect(selection.state.selection, ['short', 'value', '']);
    expect(selection.state.positions, [0, 0, 0]);
    expect(selection.state.column(2), ['']);
  });

  test('Linked Picker state exposes immutable selection snapshots', () {
    final selection = CascadingSelectionModule(
      adapter: NestedMapAdapter(
        data: const {
          'A': ['A1'],
        },
        columnCount: 2,
      ),
    );

    expect(() => selection.state.selection.add('A2'), throwsUnsupportedError);
    expect(() => selection.state.positions[0] = 1, throwsUnsupportedError);
    expect(() => selection.state.column(0).add('B'), throwsUnsupportedError);
  });
}
