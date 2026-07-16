import 'package:flutter/cupertino.dart';
import 'package:flutter_pickers/src/route/picker_popup_route.dart';
import 'package:flutter_pickers/src/route/picker_sheet.dart';
import 'package:flutter_pickers/style/picker_style.dart';

typedef MultipleCallback = Function(List res, List<int> position);

/// 将编辑区解析出的值同步回每一列；全部值都能匹配数据源时返回 true。
typedef MultiplePickerSelectionUpdater = bool Function(List selection);

/// 构建选择器下方的自定义编辑区。
///
/// [selection] 是当前各列选中值的只读快照。编辑内容解析为完整选项后，
/// 调用 [updateSelection] 即可驱动各列滚轮同步更新。
typedef MultiplePickerEditorBuilder = Widget Function(
  BuildContext context,
  List selection,
  MultiplePickerSelectionUpdater updateSelection,
);

/// 多项选择器
/// 无关联
class MultiplePickerRoute<T> extends PickerPopupRoute<T> {
  MultiplePickerRoute({
    required super.pickerStyle,
    required this.data,
    required this.selectData,
    this.suffix,
    this.onChanged,
    this.onConfirm,
    super.onCancel,
    this.editorBuilder,
    this.editorHeight = 56.0,
    super.theme,
    super.barrierLabel,
    super.settings,
  });

  final List<List> data;
  final List selectData;
  final List? suffix;
  final MultipleCallback? onChanged;
  final MultipleCallback? onConfirm;
  final MultiplePickerEditorBuilder? editorBuilder;
  final double editorHeight;

  @override
  Widget buildPickerContent(
    BuildContext context,
    PickerStyle resolvedStyle,
    double safeAreaBottom,
  ) {
    return PickerContentView(
      data: data,
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
    required this.pickerStyle,
    required this.selectData,
    this.safeAreaBottom = 0.0,
    required this.route,
  });

  final List<List> data;
  final List selectData;
  final MultiplePickerRoute route;
  final PickerStyle pickerStyle;
  final double safeAreaBottom;

  @override
  State<PickerContentView> createState() => _PickerState();
}

class _PickerState extends State<PickerContentView> {
  late final PickerStyle _pickerStyle;
  late List _selectData;
  late List<int> _selectDataPosition;
  late List<List> _data;

  List<FixedExtentScrollController> scrollCtrl = [];

  @override
  void initState() {
    super.initState();

    _data = widget.data;
    List mSelectData = widget.selectData;
    _pickerStyle = widget.pickerStyle;
    // 已选择器数据为准，因为初始化数据有可能和选择器对不上
    _selectData = [];
    _selectDataPosition = [];
    _data.asMap().keys.forEach((index) {
      if (index >= mSelectData.length) {
        _selectData.add('');
      } else {
        _selectData.add(mSelectData[index]);
      }
      _selectDataPosition.add(0);
    });
    _init();
  }

  @override
  void dispose() {
    for (var element in scrollCtrl) {
      element.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardInset = MediaQuery.of(context).viewInsets.bottom;
    final editor = widget.route.editorBuilder?.call(
      context,
      List.unmodifiable(_selectData),
      _updateSelectionFromEditor,
    );

    return AnimatedPadding(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.only(bottom: keyboardInset),
      child: PickerSheet(
        animation: widget.route.animation!,
        style: _pickerStyle,
        safeAreaBottom: widget.safeAreaBottom,
        body: _renderItemView(),
        footer: editor,
        footerHeight: editor == null ? 0.0 : widget.route.editorHeight,
        onConfirm: () {
          FocusScope.of(context).unfocus();
          widget.route.onConfirm?.call(_selectData, _selectDataPosition);
        },
      ),
    );
  }

  void _init() {
    int pindex;
    scrollCtrl.clear();

    _data.asMap().keys.forEach((index) {
      pindex = 0;
      pindex = _data[index].indexWhere(
        (element) => element.toString() == _selectData[index].toString(),
      );
      // 如果没有匹配到选择器对应数据，我们得修改选择器选中数据 ，不然confirm 返回的事设置的数据
      if (pindex < 0) {
        _selectData[index] = _data[index][0];
        pindex = 0;
      }
      _selectDataPosition[index] = pindex;

      scrollCtrl.add(FixedExtentScrollController(initialItem: pindex));
    });
  }

  void _setPicker(int index, int selectIndex) {
    var selectedName = _data[index][selectIndex];

    if (_selectDataPosition[index] == selectIndex &&
        _selectData[index].toString() == selectedName.toString()) {
      return;
    }

    void updateSelection() {
      _selectData[index] = selectedName;
      _selectDataPosition[index] = selectIndex;
    }

    if (widget.route.editorBuilder == null) {
      updateSelection();
    } else {
      setState(updateSelection);
    }

    _notifyLocationChanged();
  }

  bool _updateSelectionFromEditor(List selection) {
    if (selection.length != _data.length) {
      return false;
    }

    final positions = <int>[];
    for (var column = 0; column < _data.length; column++) {
      final position = _data[column].indexWhere(
        (item) => item.toString() == selection[column].toString(),
      );
      if (position < 0) {
        return false;
      }
      positions.add(position);
    }

    final changed = positions.asMap().entries.any(
          (entry) => _selectDataPosition[entry.key] != entry.value,
        );
    if (!changed) {
      return true;
    }

    setState(() {
      for (var column = 0; column < _data.length; column++) {
        final position = positions[column];
        _selectData[column] = _data[column][position];
        _selectDataPosition[column] = position;
        scrollCtrl[column].jumpToItem(position);
      }
    });
    _notifyLocationChanged();
    return true;
  }

  void _notifyLocationChanged() {
    widget.route.onChanged?.call(_selectData, _selectDataPosition);
  }

  Widget _renderItemView() {
    // 选择器
    List<Widget> pickerList = List.generate(
      _data.length,
      (index) => pickerView(index),
    ).toList();

    return Row(children: pickerList);
  }

  Widget pickerView(int position) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: CupertinoPicker.builder(
          scrollController: scrollCtrl[position],
          selectionOverlay: _pickerStyle.itemOverlay,
          itemExtent: _pickerStyle.pickerItemHeight,
          onSelectedItemChanged: (int selectIndex) =>
              _setPicker(position, selectIndex),
          childCount: _data[position].length,
          itemBuilder: (_, index) {
            // String text = _data[position][index].toString();
            String suffix = '';
            if (widget.route.suffix != null &&
                position < widget.route.suffix!.length) {
              suffix = widget.route.suffix![position];
            }

            String text = '${_data[position][index]}$suffix';
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
