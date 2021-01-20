import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pickers/more_pickers/init_data.dart';
import 'package:flutter_pickers/style/picker_style.dart';

typedef SingleCallback(var data);

// const double _pickerHeight = 220.0;
// const double _pickerTitleHeight = 44.0;
// const double _pickerItemHeight = 40.0;
// double _pickerMenuHeight = 36.0;

class SinglePickerRoute<T> extends PopupRoute<T> {
  SinglePickerRoute({
    // this.menu,
    // this.menuHeight,
    // this.cancelWidget,
    // this.commitWidget,
    // this.labelWidget,

    // this.headDecoration,
    // this.title,
    // this.backgroundColor,
    // this.textColor,
    // this.showTitleBar,

    this.data,
    this.selectData,
    this.suffix,
    this.onChanged,
    this.onConfirm,
    this.theme,
    this.barrierLabel,
    this.pickerStyle,
    RouteSettings settings,
  }) : super(settings: settings);

  final dynamic selectData;
  final dynamic data;
  final SingleCallback onChanged;
  final SingleCallback onConfirm;
  final ThemeData theme;

  // final bool showTitleBar;
  // final Color backgroundColor; // 背景色
  // final Color textColor; // 文字颜色
  // final Widget title;
  // final Widget menu;
  // final double menuHeight;
  // final Widget cancelWidget;
  // final Widget commitWidget;
  // final Decoration headDecoration; // 头部样式
  // final Widget labelWidget;
  final String suffix;
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
    List mData = [];
    // 初始化数据
    if (data is PickerDataType) {
      mData = pickerData[data];
    } else if (data is List) {
      mData.addAll(data);
    }

    Widget bottomSheet = MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: _PickerContentView(
        data: mData,
        selectData: selectData,
        pickerStyle :pickerStyle,
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
    this.selectData,
    this.pickerStyle,
    @required this.route,
  }) : super(key: key);

  final List data;
  final dynamic selectData;
  final SinglePickerRoute route;
  final PickerStyle pickerStyle;

  @override
  State<StatefulWidget> createState() => _PickerState(this.data, this.selectData, this.pickerStyle);
}

class _PickerState extends State<_PickerContentView> {
  final PickerStyle _pickerStyle;
  var _selectData;
  List _data = [];

  AnimationController controller;
  Animation<double> animation;

  FixedExtentScrollController scrollCtrl;

  // 单位widget Padding left
  double _laberLeft;

  _PickerState(this._data, this._selectData, this._pickerStyle) {
    _init();
  }

  @override
  void dispose() {
    scrollCtrl.dispose();

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
              delegate: _BottomPickerLayout(widget.route.animation.value, pickerStyle : _pickerStyle),
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
    int pindex = 0;
    pindex = _data.indexWhere((element) => element.toString() == _selectData.toString());
    // 如果没有匹配到选择器对应数据，我们得修改选择器选中数据 ，不然confirm 返回的事设置的数据
    if (pindex < 0) {
      _selectData = _data[0];
      pindex = 0;
    }

    scrollCtrl = new FixedExtentScrollController(initialItem: pindex);
    _laberLeft = _pickerLaberPadding(_data[pindex].toString());
  }

  void _setPicker(int index) {
    var selectedProvince = _data[index];

    if (_selectData.toString() != selectedProvince.toString()) {
      setState(() {
        _selectData = selectedProvince;
      });

      _notifyLocationChanged();
    }
  }

  void _notifyLocationChanged() {
    if (widget.route.onChanged != null) {
      widget.route.onChanged(_selectData);
    }
  }

  double _pickerLaberPadding(String text) {
    double left = 80;

    if (text != null) {
      left = left + text.length * 12;
    }
    return left;
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
    Widget cPicker = CupertinoPicker.builder(
      scrollController: scrollCtrl,
      itemExtent: _pickerStyle.pickerItemHeight,
      onSelectedItemChanged: (int index) {
        _setPicker(index);
        if (widget.route.suffix != null && widget.route.suffix != '') {
          // 如果设置了才计算 单位的paddingLeft
          double resuleLeft = _pickerLaberPadding(_data[index].toString());
          if (resuleLeft != _laberLeft) {
            setState(() {
              _laberLeft = resuleLeft;
            });
          }
        }
      },
      childCount: _data.length,
      itemBuilder: (_, index) {
        String text = _data[index].toString();
        return Align(
            alignment: Alignment.center,
            child: Text(text,
                style: TextStyle(color: _pickerStyle.textColor, fontSize: _pickerFontSize(text)),
                textAlign: TextAlign.start));
      },
    );

    Widget view;
    // 单位
    if ((widget.route.suffix != null && widget.route.suffix != '') || (_pickerStyle.labelWidget != null)) {
      Widget laberView = Container(
          alignment: Alignment.center,
          child: (_pickerStyle.labelWidget == null)
              ? AnimatedPadding(
                  duration: Duration(milliseconds: 100),
                  padding: EdgeInsets.only(left: _laberLeft),
                  child: Text(widget.route.suffix,
                      style: TextStyle(color: _pickerStyle.textColor, fontSize: 20, fontWeight: FontWeight.w500)),
                )
              : _pickerStyle.labelWidget);

      view = Stack(children: [cPicker, laberView]);
    } else {
      view = cPicker;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 40),
      height: _pickerStyle.pickerHeight,
      color: _pickerStyle.backgroundColor,
      child: view,
    );
  }

  // 选择器上面的view
  Widget _titleView() {
    // final commitButton = Container(
    //   height: _pickerTitleHeight,
    //   alignment: Alignment.center,
    //   padding: const EdgeInsets.only(left: 12, right: 22),
    //   child: Text('确定', style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16.0)),
    // );
    //
    // final cancelButton = Container(
    //   alignment: Alignment.center,
    //   height: _pickerTitleHeight,
    //   padding: const EdgeInsets.only(left: 22, right: 12),
    //   child: Text('取消', style: TextStyle(color: Theme.of(context).unselectedWidgetColor, fontSize: 16.0)),
    // );

    // final headDecoration = BoxDecoration(color: Colors.white);

    return Container(
      height: _pickerStyle.pickerTitleHeight,
      decoration: _pickerStyle.headDecoration,
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          /// 取消按钮
          InkWell(
              onTap: () => Navigator.pop(context),
              child: _pickerStyle.cancelButton),

          /// 标题
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
  // final bool showTitleBar;
  // final bool showMenu;

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
