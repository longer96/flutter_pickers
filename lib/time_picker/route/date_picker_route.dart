import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_pickers/src/date_picker/date_selection.dart';
import 'package:flutter_pickers/src/route/picker_popup_route.dart';
import 'package:flutter_pickers/src/route/picker_sheet.dart';
import 'package:flutter_pickers/style/picker_style.dart';
import 'package:flutter_pickers/time_picker/model/date_mode.dart';
import 'package:flutter_pickers/time_picker/model/date_type.dart';
import 'package:flutter_pickers/time_picker/model/pduration.dart';
import 'package:flutter_pickers/time_picker/model/suffix.dart';

typedef DateCallback = Function(PDuration res);

class DatePickerRoute<T> extends PickerPopupRoute<T> {
  DatePickerRoute({
    required this.mode,
    required this.initDate,
    super.pickerStyle,
    required this.maxDate,
    required this.minDate,
    this.suffix,
    this.onChanged,
    this.onConfirm,
    super.onCancel,
    super.theme,
    super.barrierLabel,
    super.settings,
  });

  final DateMode mode;
  late final PDuration initDate;
  late final PDuration maxDate;
  late final PDuration minDate;
  final Suffix? suffix;
  final DateCallback? onChanged;
  final DateCallback? onConfirm;

  @override
  Widget buildPickerContent(
    BuildContext context,
    PickerStyle resolvedStyle,
    double safeAreaBottom,
  ) {
    return PickerContentView(
      mode: mode,
      initData: initDate,
      maxDate: maxDate,
      minDate: minDate,
      pickerStyle: resolvedStyle,
      safeAreaBottom: safeAreaBottom,
      route: this,
    );
  }
}

class PickerContentView extends StatefulWidget {
  const PickerContentView({
    super.key,
    required this.mode,
    required this.initData,
    required this.pickerStyle,
    required this.maxDate,
    required this.minDate,
    this.safeAreaBottom = 0.0,
    required this.route,
  });

  final DateMode mode;
  final PDuration initData;
  final DatePickerRoute route;
  final PickerStyle pickerStyle;
  final double safeAreaBottom;
  final PDuration maxDate;
  final PDuration minDate;

  @override
  State<PickerContentView> createState() => _PickerState();
}

class _PickerState extends State<PickerContentView> {
  late final PickerStyle _pickerStyle;
  late final DateSelectionModule _selection;
  late final PDuration _selectData;
  late Suffix _suffix;
  bool _isInitialized = false;

  final Map<DateType, FixedExtentScrollController> scrollCtrl = {};
  late double pickerItemHeight;

  @override
  void initState() {
    super.initState();
    _pickerStyle = widget.pickerStyle;
    pickerItemHeight = _pickerStyle.pickerItemHeight;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInitialized) return;

    _isInitialized = true;
    _suffix = widget.route.suffix ?? Suffix.fromContext(context);
    _selection = DateSelectionModule(
      mode: widget.mode,
      initial: widget.initData,
      min: widget.minDate,
      max: widget.maxDate,
    );
    _selectData = _selection.state.toDuration();
    for (final type in _selection.state.types) {
      scrollCtrl[type] = FixedExtentScrollController(
        initialItem: _selection.state.position(type),
      );
    }
  }

  @override
  void dispose() {
    for (final controller in scrollCtrl.values) {
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
      onConfirm: () => widget.route.onConfirm?.call(_selectData),
    );
  }

  void _setPicker(DateType type, int index) {
    final previous = _selection.state;
    final next = _selection.select(type, index);
    final columnsChanged = next.types.any(
      (column) => !listEquals(previous.values(column), next.values(column)),
    );

    setState(() {
      _copySelection(next.toDuration());
      for (final column in next.types) {
        if (column != type &&
            previous.position(column) != next.position(column)) {
          scrollCtrl[column]?.jumpToItem(next.position(column));
        }
      }
      if (columnsChanged) {
        // Work around https://github.com/flutter/flutter/issues/22999.
        pickerItemHeight =
            _pickerStyle.pickerItemHeight - Random().nextDouble() / 100000000;
      }
    });

    widget.route.onChanged?.call(_selectData);
  }

  void _copySelection(PDuration value) {
    _selectData
      ..year = value.year
      ..month = value.month
      ..day = value.day
      ..hour = value.hour
      ..minute = value.minute
      ..second = value.second;
  }

  Widget _renderItemView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: _selection.state.types.map(pickerView).toList(),
    );
  }

  Widget pickerView(DateType type) {
    final values = _selection.state.values(type);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: CupertinoPicker.builder(
          scrollController: scrollCtrl[type],
          itemExtent: pickerItemHeight,
          selectionOverlay: _pickerStyle.itemOverlay,
          onSelectedItemChanged: (index) => _setPicker(type, index),
          childCount: values.length,
          itemBuilder: (_, index) {
            final text = '${values[index]}${_suffix.getSingle(type)}';
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
                  overflow: TextOverflow.ellipsis,
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
