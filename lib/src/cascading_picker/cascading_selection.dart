import 'dart:collection';

/// Interprets one data shape at the cascading Selection seam.
abstract class CascadingDataAdapter {
  int get columnCount;

  List valuesFor(int column, List selection);
}

/// Pure Linked Picker state shared by every cascading data adapter.
class CascadingSelectionModule {
  CascadingSelectionModule({
    required CascadingDataAdapter adapter,
    List initial = const [],
  }) : _adapter = adapter {
    _state = _derive(initial);
  }

  final CascadingDataAdapter _adapter;
  late CascadingSelectionState _state;

  CascadingSelectionState get state => _state;

  CascadingSelectionState select(int column, int index) {
    if (column < 0 || column >= _adapter.columnCount) {
      throw RangeError.range(column, 0, _adapter.columnCount - 1, 'column');
    }
    final values = _state.column(column);
    if (index < 0 || index >= values.length) {
      throw RangeError.index(index, values, 'index');
    }

    final desired = _state.selection.take(column).toList()..add(values[index]);
    _state = _derive(desired);
    return _state;
  }

  CascadingSelectionState _derive(List desired) {
    final columns = <List>[];
    final selection = <dynamic>[];
    final positions = <int>[];

    for (var column = 0; column < _adapter.columnCount; column++) {
      final values = List.unmodifiable(
        List.from(_adapter.valuesFor(column, selection)),
      );
      if (values.isEmpty) {
        throw StateError('Linked Picker column $column has no values');
      }

      final desiredValue = column < desired.length ? desired[column] : null;
      var position = values.indexOf(desiredValue);
      if (position < 0) position = 0;

      columns.add(values);
      positions.add(position);
      selection.add(values[position]);
    }

    return CascadingSelectionState._(columns, selection, positions);
  }
}

class CascadingSelectionState {
  CascadingSelectionState._(
    List<List> columns,
    List selection,
    List<int> positions,
  )   : _columns = UnmodifiableListView(
          columns.map((column) => UnmodifiableListView(List.from(column))),
        ),
        selection = UnmodifiableListView(List.from(selection)),
        positions = UnmodifiableListView(List<int>.from(positions));

  final List<List> _columns;
  final List selection;
  final List<int> positions;

  int get columnCount => _columns.length;

  List column(int index) => _columns[index];
}
