import 'package:flutter/cupertino.dart';
import 'package:flutter_pickers/src/cascading_picker/address_adapter.dart';
import 'package:flutter_pickers/src/cascading_picker/cascading_selection.dart';
import 'package:flutter_pickers/src/route/picker_popup_route.dart';
import 'package:flutter_pickers/src/route/picker_sheet.dart';
import 'package:flutter_pickers/style/picker_style.dart';

import '../locations_data.dart';

typedef AddressCallback = Function(String province, String city, String? town);

/// 自定义 地区选择器
/// [initProvince] 初始化 省
/// [initCity]    初始化 市
/// [initTown]    初始化 区
/// [onChanged]   选择器发生变动
/// [onConfirm]   选择器提交
/// [addAllItem] 市、区是否添加 '全部' 选项     默认：true
class AddressPickerRoute<T> extends PickerPopupRoute<T> {
  AddressPickerRoute({
    required this.addAllItem,
    required super.pickerStyle,
    required this.initProvince,
    required this.initCity,
    this.initTown,
    this.onChanged,
    this.onConfirm,
    super.onCancel,
    super.theme,
    super.barrierLabel,
    super.settings,
  });

  late final String initProvince, initCity;
  final String? initTown;
  final AddressCallback? onChanged;
  final AddressCallback? onConfirm;
  final bool addAllItem;

  @override
  Widget buildPickerContent(
    BuildContext context,
    PickerStyle resolvedStyle,
    double safeAreaBottom,
  ) {
    return PickerContentView(
      initProvince: initProvince,
      initCity: initCity,
      initTown: initTown,
      addAllItem: addAllItem,
      pickerStyle: resolvedStyle,
      safeAreaBottom: safeAreaBottom,
      route: this,
    );
  }
}

class PickerContentView extends StatefulWidget {
  const PickerContentView({
    super.key,
    required this.initProvince,
    required this.initCity,
    this.initTown,
    required this.pickerStyle,
    required this.addAllItem,
    this.safeAreaBottom = 0.0,
    required this.route,
  });

  final String initProvince, initCity;
  final String? initTown;
  final AddressPickerRoute route;
  final bool addAllItem;
  final PickerStyle pickerStyle;
  final double safeAreaBottom;

  @override
  State<PickerContentView> createState() => _PickerState();
}

class _PickerState extends State<PickerContentView> {
  late final PickerStyle _pickerStyle;
  late final CascadingSelectionModule _selection;
  final List<FixedExtentScrollController> scrollCtrl = [];
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _pickerStyle = widget.pickerStyle;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInitialized) return;

    _isInitialized = true;
    final hasTown = widget.initTown != null;
    _selection = CascadingSelectionModule(
      adapter: AddressAdapter(
        allText: getAllText(context),
        addAllItem: widget.addAllItem,
        hasTown: hasTown,
      ),
      initial: [
        widget.initProvince,
        widget.initCity,
        if (hasTown) widget.initTown,
      ],
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
      onConfirm: () => _notify(widget.route.onConfirm),
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
    });
    _notify(widget.route.onChanged);
  }

  void _notify(AddressCallback? callback) {
    if (callback == null) return;
    final values = _selection.state.selection;
    callback(
      values[0] as String,
      values[1] as String,
      values.length > 2 ? values[2] as String : null,
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
        padding: const EdgeInsets.all(8),
        child: CupertinoPicker.builder(
          scrollController: scrollCtrl[column],
          selectionOverlay: _pickerStyle.itemOverlay,
          itemExtent: _pickerStyle.pickerItemHeight,
          onSelectedItemChanged: (index) => _setPicker(column, index),
          childCount: values.length,
          itemBuilder: (_, index) {
            final text = values[index] as String;
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
