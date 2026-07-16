import 'package:flutter_pickers/src/cascading_picker/cascading_selection.dart';

class NestedMapAdapter implements CascadingDataAdapter {
  NestedMapAdapter({
    required Map data,
    required this.columnCount,
    this.placeholder = '',
  }) : _data = data;

  final Map _data;

  @override
  final int columnCount;

  final dynamic placeholder;

  @override
  List valuesFor(int column, List selection) {
    dynamic node = _data;
    for (var index = 0; index < column; index++) {
      if (node is! Map || index >= selection.length) {
        return [placeholder];
      }
      node = node[selection[index]];
    }

    if (node is Map) return node.keys.toList();
    if (node is List) return List.from(node);
    if (node == null) return [placeholder];
    return [node];
  }
}
