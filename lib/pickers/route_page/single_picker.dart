import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pickers/pickers/init_data.dart';

typedef SingleCallback(var data);

const double _pickerHeight = 220.0;
const double _pickerTitleHeight = 44.0;
const double _pickerItemHeight = 40.0;
double _pickerMenuHeight = 36.0;

class SinglePickerRoute<T> extends PopupRoute<T> {
  SinglePickerRoute({
    this.menu,
    this.menuHeight,
    this.cancelWidget,
    this.commitWidget,
    this.labelWidget,
    this.label,
    this.headDecoration,
    this.title,
    this.backgroundColor,
    this.textColor,
    this.showTitleBar,
    this.data,
    this.selectData,
    this.onChanged,
    this.onConfirm,
    this.theme,
    this.barrierLabel,
    RouteSettings settings,
  }) : super(settings: settings) {
    if (menuHeight != null) _pickerMenuHeight = menuHeight;
  }

  final bool showTitleBar;
  final dynamic selectData;
  final dynamic data;
  final SingleCallback onChanged;
  final SingleCallback onConfirm;
  final ThemeData theme;

  final Color backgroundColor; // 背景色
  final Color textColor; // 文字颜色
  final Widget title;
  final Widget menu;
  final double menuHeight;
  final Widget cancelWidget;
  final Widget commitWidget;
  final Decoration headDecoration; // 头部样式
  final Widget labelWidget;
  final String label;

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
        onChanged: onChanged,
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
    @required this.route,
    this.onChanged,
  }) : super(key: key);

  final List data;
  final dynamic selectData;
  final SingleCallback onChanged;
  final SinglePickerRoute route;

  @override
  State<StatefulWidget> createState() => _PickerState(this.data, this.selectData);
}

class _PickerState extends State<_PickerContentView> {
  var _selectData;
  List data = [];

  AnimationController controller;
  Animation<double> animation;

  FixedExtentScrollController provinceScrollCtrl;

  // 单位widget Padding left
  double _laberLeft;

  _PickerState(this.data, this._selectData) {
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: AnimatedBuilder(
        animation: widget.route.animation,
        builder: (BuildContext context, Widget child) {
          return ClipRect(
            child: CustomSingleChildLayout(
              delegate: _BottomPickerLayout(widget.route.animation.value,
                  showTitleActions: widget.route.showTitleBar, showMenu: widget.route.menu != null),
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
    pindex = data.indexWhere((element) => element.toString() == _selectData.toString());
    pindex = pindex >= 0 ? pindex : 0;

    provinceScrollCtrl = new FixedExtentScrollController(initialItem: pindex);
    _laberLeft = _pickerLaberPadding(data[pindex].toString());
  }

  void _setPicker(int index) {
    var selectedProvince = data[index];

    if (_selectData.toString() != selectedProvince.toString()) {
      setState(() {
        _selectData = selectedProvince;
      });

      _notifyLocationChanged();
    }
  }

  void _notifyLocationChanged() {
    if (widget.onChanged != null) {
      widget.onChanged(_selectData);
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

    if (!widget.route.showTitleBar && widget.route.menu == null) {
      return itemView;
    }
    List viewList = <Widget>[];
    if (widget.route.showTitleBar) {
      viewList.add(_titleView());
    }
    if (widget.route.menu != null) {
      viewList.add(widget.route.menu);
    }
    viewList.add(itemView);

    return Column(children: viewList);
  }

  Widget _renderItemView() {
    // 选择器
    Widget cPicker = CupertinoPicker(
      scrollController: provinceScrollCtrl,
      itemExtent: _pickerItemHeight,
      onSelectedItemChanged: (int index) {
        _setPicker(index);

        if (widget.route.label != null && widget.route.label != '') {
          // 如果设置了才计算 单位的paddingLeft
          double resuleLeft = _pickerLaberPadding(data[index].toString());
          if (resuleLeft != _laberLeft) {
            setState(() {
              _laberLeft = resuleLeft;
            });
          }
        }
      },
      children: List.generate(data.length, (int index) {
        String text = data[index].toString();
        return Container(
            alignment: Alignment.center,
            child: Text(text,
                style: TextStyle(color: widget.route.textColor, fontSize: _pickerFontSize(text)),
                textAlign: TextAlign.start));
      }),
    );

    Widget view;
    // 单位
    if ((widget.route.label != null && widget.route.label != '') || (widget.route.labelWidget != null)) {
      Widget laberView = Container(
          height: _pickerHeight,
          alignment: Alignment.center,
          child: (widget.route.labelWidget == null)
              ? AnimatedPadding(
                  duration: Duration(milliseconds: 100),
                  padding: EdgeInsets.only(left: _laberLeft),
                  child: Text(widget.route.label,
                      style: TextStyle(color: widget.route.textColor, fontSize: 20, fontWeight: FontWeight.w500)),
                )
              : widget.route.labelWidget);

      view = Stack(children: [cPicker, laberView]);
    } else {
      view = cPicker;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 40),
      height: _pickerHeight,
      color: widget.route.backgroundColor,
      child: view,
    );
  }

  // 选择器上面的view
  Widget _titleView() {
    final commitButton = Container(
      height: _pickerTitleHeight,
      child: FlatButton(
          onPressed: null, child: Text('确定', style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16.0))),
    );

    final cancelButton = Container(
      alignment: Alignment.center,
      height: _pickerTitleHeight,
      child: FlatButton(
          onPressed: null,
          child: Text('取消', style: TextStyle(color: Theme.of(context).unselectedWidgetColor, fontSize: 16.0))),
    );

    final headDecoration = BoxDecoration(color: Colors.white);

    return Container(
      height: _pickerTitleHeight,
      decoration: (widget.route.headDecoration == null) ? headDecoration : widget.route.headDecoration,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          /// 取消按钮
          InkWell(
              onTap: () => Navigator.pop(context),
              child: (widget.route.cancelWidget == null) ? cancelButton : widget.route.cancelWidget),

          /// 分割线
          (widget.route.title != null) ? widget.route.title : SizedBox(),

          /// 确认按钮
          InkWell(
              onTap: () {
                widget.route?.onConfirm(_selectData);
                Navigator.pop(context);
              },
              child: (widget.route.commitWidget == null) ? commitButton : widget.route.commitWidget)
        ],
      ),
    );
  }
}

class _BottomPickerLayout extends SingleChildLayoutDelegate {
  _BottomPickerLayout(this.progress, {this.itemCount, this.showTitleActions, this.showMenu});

  final double progress;
  final int itemCount;
  final bool showTitleActions;
  final bool showMenu;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    double maxHeight = _pickerHeight;
    if (showTitleActions) {
      maxHeight += _pickerTitleHeight;
    }
    if (showMenu) {
      maxHeight += _pickerMenuHeight;
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
