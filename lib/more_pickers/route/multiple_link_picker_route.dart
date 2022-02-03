import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pickers/style/picker_style.dart';

typedef MultipleLinkCallback(List res, List<int> position);

/// 多项选择器
/// 有关联
class MultipleLinkPickerRoute<T> extends PopupRoute<T> {
  MultipleLinkPickerRoute({
    required this.pickerStyle,
    required this.data,
    required this.selectData,
    required this.columeNum,
    this.suffix,
    this.onChanged,
    this.onConfirm,
    this.onCancel,
    this.theme,
    this.barrierLabel,
    RouteSettings? settings,
  }) : super(settings: settings);

  final Map data;
  final int columeNum;
  final List selectData;
  final List? suffix;
  final MultipleLinkCallback? onChanged;
  final MultipleLinkCallback? onConfirm;
  final Function(bool isCancel)? onCancel;
  final ThemeData? theme;

  final PickerStyle pickerStyle;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  @override
  bool get barrierDismissible => true;

  @override
  bool didPop(T? result) {
    if (onCancel != null) {
      if (result == null) {
        onCancel!(false);
      } else if (!(result as bool)) {
        onCancel!(true);
      }
    }
    return super.didPop(result);
  }

  @override
  final String? barrierLabel;

  @override
  Color get barrierColor => Colors.black54;

  late AnimationController _animationController;

  @override
  AnimationController createAnimationController() {
    _animationController =
        BottomSheet.createAnimationController(navigator!.overlay!);
    return _animationController;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    Widget bottomSheet = MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: _PickerContentView(
        data: data,
        columeNum: columeNum,
        selectData: selectData,
        pickerStyle: pickerStyle,
        route: this,
      ),
    );
    if (theme != null) {
      bottomSheet = Theme(data: theme!, child: bottomSheet);
    }

    return bottomSheet;
  }
}

class _PickerContentView extends StatefulWidget {
  _PickerContentView({
    Key? key,
    required this.data,
    required this.columeNum,
    required this.pickerStyle,
    required this.selectData,
    required this.route,
  }) : super(key: key);

  final Map data;
  final int columeNum;
  final List selectData;
  final MultipleLinkPickerRoute route;
  final PickerStyle pickerStyle;

  @override
  State<StatefulWidget> createState() => _PickerState(
      this.data, this.selectData, this.pickerStyle, this.columeNum);
}

class _PickerState extends State<_PickerContentView> {
  final PickerStyle _pickerStyle;

  // 没有数据时占位字符
  static const placeData = '';

  /// 选中数据
  late List _selectData;

  /// 选中数据下标
  late List<int> _selectDataPosition;

  /// 原始数据
  Map _data;

  /// 有多少列
  final int _columeNum;

  /// 所有item 对应的数据
  late List<List> _columnData = [];

  AnimationController? controller;
  Animation<double>? animation;

  List<FixedExtentScrollController> scrollCtrl = [];

  // 选择器 高度  单独提出来，用来解决修改数据 不及时更新的BUG
  late double pickerItemHeight;

  _PickerState(
      this._data, List mSelectData, this._pickerStyle, this._columeNum) {
    this.pickerItemHeight = _pickerStyle.pickerItemHeight;
    // 已选择器数据为准，因为初始化数据有可能和选择器对不上
    this._selectData = [];
    this._selectDataPosition = [];
    for (int i = 0; i < _columeNum; ++i) {
      if (i >= mSelectData.length) {
        this._selectData.add('');
      } else {
        this._selectData.add(mSelectData[i]);
      }
      this._selectDataPosition.add(0);
    }

    _init(mSelectData);
  }

  @override
  void dispose() {
    scrollCtrl.forEach((element) {
      element.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: AnimatedBuilder(
        animation: widget.route.animation!,
        builder: (BuildContext context, Widget? child) {
          return ClipRect(
            child: CustomSingleChildLayout(
              delegate: _BottomPickerLayout(widget.route.animation!.value,
                  pickerStyle: _pickerStyle),
              child: GestureDetector(
                child: Material(
                  color: Colors.transparent,
                  child: _renderPickerView(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  _init(List mSelectData) {
    int pindex;
    scrollCtrl.clear();
    _columnData.clear();

    for (int i = 0; i < _columeNum; ++i) {
      pindex = 0;

      if (i == 0) {
        /// 第一列
        pindex = _data.keys.toList().indexOf(_selectData[i]);
        if (pindex < 0) {
          _selectData[i] = _data.keys.first;
          pindex = 0;
        }
        _selectDataPosition[i] = pindex;

        _columnData.add(_data.keys.toList());
      } else {
        /// 其他列
        dynamic date = findNextData(i);
        // print('longer  第$i列 >>> $date');

        if (date is Map) {
          pindex = date.keys.toList().indexOf(_selectData[i]);
          if (pindex < 0) {
            _selectData[i] = date.keys.first;
            pindex = 0;
          }

          _columnData.add(date.keys.toList());
        } else if (date is List) {
          pindex = date.indexOf(_selectData[i]);
          if (pindex < 0) {
            _selectData[i] = date.first;
            pindex = 0;
          }
          _columnData.add(date);
        } else {
          _selectData[i] = date;
          pindex = 0;

          _columnData.add([date]);
        }

        _selectDataPosition[i] = pindex;
      }

      scrollCtrl.add(FixedExtentScrollController(initialItem: pindex));
    }
  }

  /// [position] 变动的列
  /// [selectIndex] 对应列选中的index
  /// [jump] 是否需要jumpToItem
  void _setPicker(int position, int selectIndex, bool jump) {
    // 得到新的选中的数据
    var selectValue = _columnData[position][selectIndex];
    // 更新选中数据
    _selectData[position] = selectValue;
    _selectDataPosition[position] = selectIndex;
    if (jump) {
      scrollCtrl[position].jumpToItem(selectIndex);
    }

    /// 如果不是最后一列
    /// 数据的变动都会造成剩下列的更新
    if (position < _columeNum - 1) {
      // 先更新下一列所有数据
      // 如果这一列的所有数据都为空，下列直接也设为空数据(优化)
      if (_columnData[position].length == 1 &&
          _columnData[position].first == placeData) {
        _columnData[position + 1] = [placeData];
      } else {
        _columnData[position + 1] = findColumeData(position + 1);
      }

      // 再次递归
      _setPicker(position + 1, 0, true);
    } else {
      _notifyLocationChanged();
    }
  }

  /// 找到对应位置的 下一列数据
  /// return map list other
  dynamic findNextData(int position) {
    dynamic nextData;

    for (int i = 0; i < position; i++) {
      if (i == 0) {
        // 肯定是map
        nextData = _data[_selectData[0]];
      } else {
        // 肯定是map
        dynamic data = nextData[_selectData[i]];

        if (data is Map) {
          nextData = data;
        } else if (data is List) {
          nextData = data;
        } else {
          // 遍历到最后会返回该值
          nextData = [data];
        }
      }
      // print('longer  i:$i >>> $nextData');

      /// 如果数据 还没有到最后 就 已经不是Map
      if (!(nextData is Map) && (i < position - 1)) {
        return [placeData];
      }
    }

    return nextData;
  }

  /// 找到对应位置的数据
  /// 比如 position = 2;
  /// 就是找到第2列数据
  /// return list
  List findColumeData(int position) {
    dynamic nextData;
    for (int i = 0; i < position; i++) {
      if (i == 0) {
        // 肯定是map
        nextData = _data[_selectData[0]];
      } else {
        // print(
        //     'longer   选中 >>> ${_selectData.join('-')}   当前选中： ${_selectData[i]}');
        // 肯定是map
        dynamic data = nextData[_selectData[i]];

        if (data is Map) {
          nextData = data;
        } else if (data is List) {
          nextData = data;
        } else {
          // 遍历到最后会返回该值
          nextData = [data];
        }
      }
      // print('longer  i:$i >>> $nextData');

      /// 如果是map 并且是最后一列 返回他的key
      if ((nextData is Map) && (i == position - 1)) {
        return nextData.keys.toList();
      }

      /// 如果数据 还没有到最后 就 已经不是Map
      if (!(nextData is Map) && (i < position - 1)) {
        // print('longer2  第:$position列之前返回数据  >>> $nextData');
        return [placeData];
      }
    }

    // print('longer  第:$position列返回数据    >>> $nextData');
    return nextData;
  }

  void _notifyLocationChanged() {
    setState(() {
      /// FIX:https://github.com/flutter/flutter/issues/22999
      pickerItemHeight =
          _pickerStyle.pickerItemHeight - Random().nextDouble() / 100000000;
    });
    if (widget.route.onChanged != null) {
      widget.route.onChanged!(_selectData, _selectDataPosition);
    }
  }

  Widget _renderPickerView() {
    Widget itemView = _renderItemView();

    if (!_pickerStyle.showTitleBar && _pickerStyle.menu == null) {
      return itemView;
    }
    List<Widget> viewList = <Widget>[];
    if (_pickerStyle.showTitleBar) {
      viewList.add(_titleView());
    }
    if (_pickerStyle.menu != null) {
      viewList.add(_pickerStyle.menu!);
    }
    viewList.add(itemView);

    return Column(children: viewList);
  }

  Widget _renderItemView() {
    // 选择器
    List<Widget> pickerList =
        List.generate(_columeNum, (index) => pickerView(index)).toList();

    return Container(
      height: _pickerStyle.pickerHeight,
      color: _pickerStyle.backgroundColor,
      child: Row(children: pickerList),
    );
  }

  Widget pickerView(int position) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: CupertinoPicker.builder(
          scrollController: scrollCtrl[position],
          itemExtent: pickerItemHeight,
          selectionOverlay: _pickerStyle.itemOverlay,
          onSelectedItemChanged: (int selectIndex) {
            _setPicker(position, selectIndex, false);
          },
          childCount: _columnData[position].length,
          itemBuilder: (_, index) {
            // String text = _data[position][index].toString();
            String suffix = '';
            if (widget.route.suffix != null &&
                position < widget.route.suffix!.length) {
              suffix = widget.route.suffix![position];
            }

            String text = '${_columnData[position][index]}$suffix';
            return Align(
                alignment: Alignment.center,
                child: Text(text,
                    style: TextStyle(
                      color: _pickerStyle.textColor,
                      fontSize: _pickerStyle.textSize ?? 18.0,
                    ),
                    textAlign: TextAlign.start));
          },
        ),
      ),
    );
  }

  // 选择器上面的view
  Widget _titleView() {
    return Container(
      height: _pickerStyle.pickerTitleHeight,
      decoration: _pickerStyle.headDecoration,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          /// 取消按钮
          InkWell(
              onTap: () => Navigator.pop(context, false),
              child: _pickerStyle.cancelButton),

          /// 标题
          Expanded(child: _pickerStyle.title),

          /// 确认按钮
          InkWell(
              onTap: () {
                if (widget.route.onConfirm != null) {
                  widget.route.onConfirm!(_selectData, _selectDataPosition);
                }
                Navigator.pop(context, true);
              },
              child: _pickerStyle.commitButton)
        ],
      ),
    );
  }
}

class _BottomPickerLayout extends SingleChildLayoutDelegate {
  _BottomPickerLayout(this.progress, {required this.pickerStyle});

  final double progress;
  final PickerStyle pickerStyle;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    double maxHeight = pickerStyle.pickerHeight;
    if (pickerStyle.showTitleBar) {
      maxHeight += pickerStyle.pickerTitleHeight;
    }
    if (pickerStyle.menu != null) {
      maxHeight += pickerStyle.menuHeight;
    }

    return BoxConstraints(
        minWidth: constraints.maxWidth,
        maxWidth: constraints.maxWidth,
        minHeight: 0.0,
        maxHeight: maxHeight);
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    double height = size.height - childSize.height * progress;
    return Offset(0.0, height);
  }

  @override
  bool shouldRelayout(_BottomPickerLayout oldDelegate) {
    return progress != oldDelegate.progress;
  }
}
