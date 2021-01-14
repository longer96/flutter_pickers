import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef MultipleCallback(List res);

const double _pickerHeight = 220.0;
const double _pickerTitleHeight = 44.0;
const double _pickerItemHeight = 40.0;
double _pickerMenuHeight = 36.0;

class MultiplePickerRoute<T> extends PopupRoute<T> {
  MultiplePickerRoute({
    this.menu,
    this.menuHeight,
    this.cancelWidget,
    this.commitWidget,
    this.headDecoration,
    this.title,
    this.backgroundColor,
    this.textColor,
    this.showTitleBar,
    this.data,
    this.selectData,
    this.suffix,
    this.onChanged,
    this.onConfirm,
    this.theme,
    this.barrierLabel,
    RouteSettings settings,
  }) : super(settings: settings) {
    if (menuHeight != null) _pickerMenuHeight = menuHeight;
  }

  final bool showTitleBar;
  final List data;
  final List selectData;
  final List suffix;
  final MultipleCallback onChanged;
  final MultipleCallback onConfirm;
  final ThemeData theme;

  final Color backgroundColor; // 背景色
  final Color textColor; // 文字颜色
  final Widget title;
  final Widget menu;
  final double menuHeight;
  final Widget cancelWidget;
  final Widget commitWidget;
  final Decoration headDecoration; // 头部样式

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
  }) : super(key: key);

  final List<List> data;
  final List selectData;
  final MultiplePickerRoute route;

  @override
  State<StatefulWidget> createState() => _PickerState(this.data, this.selectData);
}

class _PickerState extends State<_PickerContentView> {
  List _selectData;
  List<List> _data;

  AnimationController controller;
  Animation<double> animation;

  List<FixedExtentScrollController> scrollCtrl = [];

  _PickerState(this._data, List mSelectData) {
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
    List<Widget> pickerList = [];

    pickerList = List.generate(this._data.length, (index) => pickerView(index)).toList();

    return Container(
      height: _pickerHeight,
      color: widget.route.backgroundColor,
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
          itemExtent: _pickerItemHeight,
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
                    style: TextStyle(color: widget.route.textColor, fontSize: _pickerFontSize(text)),
                    textAlign: TextAlign.start));
          },
        ),
      ),
    );
  }

  // 选择器上面的view
  Widget _titleView() {
    final commitButton = Container(
      height: _pickerTitleHeight,
      alignment: Alignment.center,
      padding: const EdgeInsets.only(left: 12, right: 22),
      child: Text('确定', style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16.0)),
    );

    final cancelButton = Container(
      height: _pickerTitleHeight,
      alignment: Alignment.center,
      padding: const EdgeInsets.only(left: 22, right: 12),
      child: Text('取消', style: TextStyle(color: Theme.of(context).unselectedWidgetColor, fontSize: 16.0)),
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
