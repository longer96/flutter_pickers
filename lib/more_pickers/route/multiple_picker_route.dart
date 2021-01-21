import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pickers/style/picker_style.dart';

typedef MultipleCallback(List res);

class MultiplePickerRoute<T> extends PopupRoute<T> {
  MultiplePickerRoute({
    this.pickerStyle,
    this.data,
    this.selectData,
    this.suffix,
    this.onChanged,
    this.onConfirm,
    this.theme,
    this.barrierLabel,
    RouteSettings settings,
  }) : super(settings: settings);

  final List data;
  final List selectData;
  final List suffix;
  final MultipleCallback onChanged;
  final MultipleCallback onConfirm;
  final ThemeData theme;

  final PickerStyle pickerStyle;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  @override
  bool get barrierDismissible => true;

  @override
  final String barrierLabel;

  @override
  Color get barrierColor => Colors.black54;

  AnimationController _animationController;

  @override
  AnimationController createAnimationController() {
    assert(_animationController == null);
    _animationController = BottomSheet.createAnimationController(navigator.overlay);
    return _animationController;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    Widget bottomSheet = MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: _PickerContentView(
        data: data,
        selectData: selectData,
        pickerStyle: pickerStyle,
        route: this,
      ),
    );
    if (theme != null) {
      bottomSheet = Theme(data: theme, child: bottomSheet);
    }

    return bottomSheet;
  }
}

class _PickerContentView extends StatefulWidget {
  _PickerContentView({
    Key key,
    this.data,
    this.pickerStyle,
    this.selectData,
    @required this.route,
  }) : super(key: key);

  final List<List> data;
  final List selectData;
  final MultiplePickerRoute route;
  final PickerStyle pickerStyle;

  @override
  State<StatefulWidget> createState() => _PickerState(this.data, this.selectData, this.pickerStyle);
}

class _PickerState extends State<_PickerContentView> {
  final PickerStyle _pickerStyle;
  List _selectData;
  List<List> _data;

  AnimationController controller;
  Animation<double> animation;

  List<FixedExtentScrollController> scrollCtrl = [];

  _PickerState(this._data, List mSelectData, this._pickerStyle) {
    // 已选择器数据为准，因为初始化数据有可能和选择器对不上
    this._selectData = [];
    this._data.asMap().keys.forEach((index) {
      if (index >= mSelectData.length) {
        this._selectData.add('');
      } else {
        this._selectData.add(mSelectData[index]);
      }
    });

    _init();
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
        animation: widget.route.animation,
        builder: (BuildContext context, Widget child) {
          return ClipRect(
            child: CustomSingleChildLayout(
              delegate: _BottomPickerLayout(widget.route.animation.value, pickerStyle: _pickerStyle),
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

  _init() {
    int pindex;
    scrollCtrl.clear();

    this._data.asMap().keys.forEach((index) {
      pindex = 0;
      pindex = _data[index].indexWhere((element) => element.toString() == _selectData[index].toString());
      // 如果没有匹配到选择器对应数据，我们得修改选择器选中数据 ，不然confirm 返回的事设置的数据
      if (pindex < 0) {
        _selectData[index] = _data[index][0];
        pindex = 0;
      }

      scrollCtrl.add(new FixedExtentScrollController(initialItem: pindex));
    });
  }

  void _setPicker(int index, int selectIndex) {
    var selectedName = _data[index][selectIndex];

    if (_selectData[index].toString() != selectedName.toString()) {
      setState(() {
        _selectData[index] = selectedName;
      });
      _notifyLocationChanged();
    }
  }

  void _notifyLocationChanged() {
    if (widget.route.onChanged != null) {
      widget.route.onChanged(_selectData);
    }
  }

  double _pickerFontSize(String text) {
    if (text == null || text.length <= 6) {
      return 18.0;
    } else if (text.length < 9) {
      return 16.0;
    } else if (text.length < 13) {
      return 12.0;
    } else {
      return 10.0;
    }
  }

  Widget _renderPickerView() {
    Widget itemView = _renderItemView();

    if (!_pickerStyle.showTitleBar && _pickerStyle.menu == null) {
      return itemView;
    }
    List viewList = <Widget>[];
    if (_pickerStyle.showTitleBar) {
      viewList.add(_titleView());
    }
    if (_pickerStyle.menu != null) {
      viewList.add(_pickerStyle.menu);
    }
    viewList.add(itemView);

    return Column(children: viewList);
  }

  Widget _renderItemView() {
    // 选择器
    List<Widget> pickerList = [];

    pickerList = List.generate(this._data.length, (index) => pickerView(index)).toList();

    return Container(
      height: _pickerStyle.pickerHeight,
      color: _pickerStyle.backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: pickerList,
      ),
    );
  }

  Widget pickerView(int position) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: CupertinoPicker.builder(
          scrollController: scrollCtrl[position],
          itemExtent: _pickerStyle.pickerItemHeight,
          onSelectedItemChanged: (int selectIndex) => _setPicker(position, selectIndex),
          childCount: _data[position].length,
          itemBuilder: (_, index) {
            // String text = _data[position][index].toString();
            String suffix = '';
            if (widget.route.suffix != null && position < widget.route.suffix.length) {
              suffix = widget.route.suffix[position];
            }

            String text = '${_data[position][index]}$suffix';
            return Align(
                alignment: Alignment.center,
                child: Text(text,
                    style: TextStyle(color: _pickerStyle.textColor, fontSize: _pickerFontSize(text)),
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
          InkWell(onTap: () => Navigator.pop(context), child: _pickerStyle.cancelButton),

          /// 分割线
          Expanded(child: _pickerStyle.title),

          /// 确认按钮
          InkWell(
              onTap: () {
                widget.route?.onConfirm(_selectData);
                Navigator.pop(context);
              },
              child: _pickerStyle.commitButton)
        ],
      ),
    );
  }
}

class _BottomPickerLayout extends SingleChildLayoutDelegate {
  _BottomPickerLayout(this.progress, {this.itemCount, this.pickerStyle});

  final double progress;
  final int itemCount;
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
        minWidth: constraints.maxWidth, maxWidth: constraints.maxWidth, minHeight: 0.0, maxHeight: maxHeight);
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
