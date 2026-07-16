import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show ThemeData;
import 'package:flutter_pickers/more_pickers/init_data.dart';
import 'package:flutter_pickers/src/route/picker_popup_route.dart';
import 'package:flutter_pickers/src/route/picker_sheet.dart';
import 'package:flutter_pickers/style/picker_style.dart';

typedef SingleCallback = Function(dynamic data, int position);

class SinglePickerRoute<T> extends PickerPopupRoute<T> {
  SinglePickerRoute({
    required this.data,
    this.selectData,
    this.suffix,
    this.onChanged,
    this.onConfirm,
    super.onCancel,
    required super.theme,
    super.barrierLabel,
    required super.pickerStyle,
    super.settings,
  });

  final dynamic selectData;
  final dynamic data;
  final SingleCallback? onChanged;
  final SingleCallback? onConfirm;

  final String? suffix;

  @override
  ThemeData get theme => super.theme!;

  @override
  Widget buildPickerContent(
    BuildContext context,
    PickerStyle resolvedStyle,
    double safeAreaBottom,
  ) {
    List mData = [];
    // 初始化数据
    if (data is PickerDataType) {
      mData = pickerData[data]!;
    } else if (data is List) {
      mData.addAll(data);
    }

    return PickerContentView(
      data: mData,
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
    this.selectData,
    required this.pickerStyle,
    this.safeAreaBottom = 0.0,
    required this.route,
  });

  final List data;
  final dynamic selectData;
  final SinglePickerRoute route;
  final PickerStyle pickerStyle;
  final double safeAreaBottom;

  @override
  State<PickerContentView> createState() => _PickerState();
}

class _PickerState extends State<PickerContentView> {
  late PickerStyle _pickerStyle;

  // 选中数据
  dynamic _selectData;

  // 选中数据下标
  int _selectPosition = 0;

  List _data = [];

  late FixedExtentScrollController scrollCtrl;

  // 单位widget Padding left
  late double _labelLeft;

  @override
  void initState() {
    super.initState();
    _data = widget.data;
    _selectData = widget.selectData;
    _pickerStyle = widget.pickerStyle;
    _init();
  }

  @override
  void dispose() {
    scrollCtrl.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PickerSheet(
      animation: widget.route.animation!,
      style: _pickerStyle,
      safeAreaBottom: widget.safeAreaBottom,
      bodyPadding: const EdgeInsets.symmetric(horizontal: 40),
      body: _renderItemView(),
      onConfirm: () {
        widget.route.onConfirm?.call(_selectData, _selectPosition);
      },
    );
  }

  void _init() {
    int pindex = 0;
    pindex = _data.indexWhere(
      (element) => element.toString() == _selectData.toString(),
    );
    // 如果没有匹配到选择器对应数据，我们得修改选择器选中数据 ，不然confirm 返回的事设置的数据
    if (pindex < 0) {
      _selectData = _data[0];
      pindex = 0;
    }
    _selectPosition = pindex;

    scrollCtrl = FixedExtentScrollController(initialItem: pindex);
    _labelLeft = _pickerLabelPadding(_data[pindex].toString());
  }

  void _setPicker(int index) {
    var selectedProvince = _data[index];

    // if (_selectData.toString() != selectedProvince.toString()) {
    // setState(() {
    // });
    _selectData = selectedProvince;
    _selectPosition = index;

    _notifyLocationChanged();
    // }
  }

  void _notifyLocationChanged() {
    widget.route.onChanged?.call(_selectData, _selectPosition);
  }

  double _pickerLabelPadding(String? text) {
    double left = 60;

    if (text != null) {
      left = left + text.length * 12;
    }
    return left;
  }

  Widget _renderItemView() {
    // 选择器
    Widget cPicker = CupertinoPicker.builder(
      scrollController: scrollCtrl,
      itemExtent: _pickerStyle.pickerItemHeight,
      selectionOverlay: _pickerStyle.itemOverlay,
      onSelectedItemChanged: (int index) {
        _setPicker(index);
        if (widget.route.suffix != null && widget.route.suffix != '') {
          // 如果设置了才计算 单位的paddingLeft
          double resultLeft = _pickerLabelPadding(_data[index].toString());
          if (resultLeft != _labelLeft) {
            setState(() {
              _labelLeft = resultLeft;
            });
          }
        }
      },
      childCount: _data.length,
      itemBuilder: (_, index) {
        String text = _data[index].toString();
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
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );

    Widget view;
    // 单位
    if (widget.route.suffix != null && widget.route.suffix != '') {
      Widget labelView = Center(
        child: AnimatedPadding(
          duration: Duration(milliseconds: 100),
          padding: EdgeInsets.only(left: _labelLeft),
          child: Text(
            widget.route.suffix!,
            style: TextStyle(
              color: _pickerStyle.textColor,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );

      view = Stack(children: [cPicker, labelView]);
    } else {
      view = cPicker;
    }

    return view;
  }
}
