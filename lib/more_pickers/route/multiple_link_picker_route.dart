import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_pickers/src/cascading_picker/cascading_selection.dart';
import 'package:flutter_pickers/src/cascading_picker/nested_map_adapter.dart';
import 'package:flutter_pickers/src/route/picker_popup_route.dart';
import 'package:flutter_pickers/src/route/picker_sheet.dart';
import 'package:flutter_pickers/style/picker_style.dart';

typedef MultipleLinkCallback = Function(List res, List<int> position);

/// 多项选择器
/// 有关联
class MultipleLinkPickerRoute<T> extends PickerPopupRoute<T> {
  MultipleLinkPickerRoute({
    required super.pickerStyle,
    required this.data,
    required this.selectData,
    required this.columnNum,
    this.suffix,
    this.onChanged,
    this.onConfirm,
    super.onCancel,
    super.theme,
    super.barrierLabel,
    super.settings,
  });

  final Map data;
  final int columnNum;
  final List selectData;
  final List? suffix;
  final MultipleLinkCallback? onChanged;
  final MultipleLinkCallback? onConfirm;

  @override
  Widget buildPickerContent(
    BuildContext context,
    PickerStyle resolvedStyle,
    double safeAreaBottom,
  ) {
    return PickerContentView(
      data: data,
      columnNum: columnNum,
      selectData: selectData,
      pickerStyle: resolvedStyle,
      safeAreaBottom: safeAreaBottom,
      route: this,
    );
  }
}

class PickerContentView extends StatefulWidget {
  const PickerContentView({
    super.key,
    required this.data,
    required this.columnNum,
    required this.pickerStyle,
    required this.selectData,
    this.safeAreaBottom = 0.0,
    required this.route,
  });

  final Map data;
  final int columnNum;
  final List selectData;
  final MultipleLinkPickerRoute route;
  final PickerStyle pickerStyle;
  final double safeAreaBottom;

  @override
  State<PickerContentView> createState() => _PickerState();
}

class _PickerState extends State<PickerContentView> {
  late final PickerStyle _pickerStyle;
  late final CascadingSelectionModule _selection;
  final List<FixedExtentScrollController> scrollCtrl = [];
  late double pickerItemHeight;

  @override
  void initState() {
    super.initState();
    _pickerStyle = widget.pickerStyle;
    pickerItemHeight = _pickerStyle.pickerItemHeight;
    _selection = CascadingSelectionModule(
      adapter: NestedMapAdapter(
        data: widget.data,
        columnCount: widget.columnNum,
      ),
      initial: widget.selectData,
    );
    for (final position in _selection.state.positions) {
      scrollCtrl.add(FixedExtentScrollController(initialItem: position));
    }
  }

  @override
  void dispose() {
    for (final controller in scrollCtrl) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PickerSheet(
      animation: widget.route.animation!,
      style: _pickerStyle,
      safeAreaBottom: widget.safeAreaBottom,
      body: _renderItemView(),
      onConfirm: () {
        widget.route.onConfirm?.call(
          List.from(_selection.state.selection),
          List<int>.from(_selection.state.positions),
        );
      },
    );
  }

  void _setPicker(int column, int index) {
    final next = _selection.select(column, index);
    setState(() {
      for (var downstream = column + 1;
          downstream < next.columnCount;
          downstream++) {
        scrollCtrl[downstream].jumpToItem(next.positions[downstream]);
      }
      // Work around https://github.com/flutter/flutter/issues/22999.
      pickerItemHeight =
          _pickerStyle.pickerItemHeight - Random().nextDouble() / 100000000;
    });
    widget.route.onChanged?.call(
      List.from(next.selection),
      List<int>.from(next.positions),
    );
  }

  Widget _renderItemView() {
    return Row(
      children: List.generate(
        _selection.state.columnCount,
        pickerView,
      ),
    );
  }

  Widget pickerView(int column) {
    final values = _selection.state.column(column);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: CupertinoPicker.builder(
          scrollController: scrollCtrl[column],
          itemExtent: pickerItemHeight,
          selectionOverlay: _pickerStyle.itemOverlay,
          onSelectedItemChanged: (index) => _setPicker(column, index),
          childCount: values.length,
          itemBuilder: (_, index) {
            var suffix = '';
            if (widget.route.suffix != null &&
                column < widget.route.suffix!.length) {
              suffix = widget.route.suffix![column];
            }
            final text = '${values[index]}$suffix';
            return Semantics(
              label: text,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  text,
                  style: TextStyle(
                    color: _pickerStyle.textColor,
                    fontSize: _pickerStyle.textSize ?? 18.0,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
