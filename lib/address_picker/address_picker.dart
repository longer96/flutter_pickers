import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'data.dart';

typedef AddressCallback(String province, String city, String town);

const double _pickerHeight = 220.0;
const double _pickerTitleHeight = 44.0;
const double _pickerItemHeight = 40.0;
double _pickerMenuHeight = 36.0;

/// 自定义 地区选择器
/// [initProvince] 初始化 省
/// [initCity]    初始化 市
/// [initTown]    初始化 区
/// [onChanged]   选择器发生变动
/// [onConfirm]   选择器提交
/// [showTitlebar]   是否显示头部 默认：true
/// [menu]   头部和选择器之间的菜单widget,默认空 不显示
/// [menuHeight]   头部和选择器之间的菜单高度  固定高度：36
/// [cancelWidget] 取消按钮
/// [commitWidget] 确认按钮
/// [title] 头部 中间的标题  默认null 不显示
/// [backgroundColor] 选择器背景色 默认白色
/// [textColor] 选择器文字颜色  默认黑色
/// [headDecoration] 头部Container Decoration 样式
/// 默认：BoxDecoration(color: Colors.white)
/// [addAllItem] 市、区是否添加 '全部' 选项     默认：true
class AddressPicker {
  static void showPicker(
    BuildContext context, {
    bool showTitlebar: true,
    Widget menu,
    double menuHeight,
    Widget cancelWidget,
    Widget commitWidget,
    Widget title,
    Decoration headDecoration,
    bool addAllItem: true,
    Color backgroundColor: Colors.white,
    Color textColor: Colors.black87,
    String initProvince: '',
    String initCity: '',
    String initTown,
    AddressCallback onChanged,
    AddressCallback onConfirm,
  }) {
    if (menuHeight != null) _pickerMenuHeight = menuHeight;

    Navigator.push(
        context,
        _PickerRoute(
          menu: menu,
          menuHeight: menuHeight,
          cancelWidget: cancelWidget,
          commitWidget: commitWidget,
          title: title,
          backgroundColor: backgroundColor,
          textColor: textColor,
          showTitlebar: showTitlebar,
          initProvince: initProvince,
          initCity: initCity,
          initTown: initTown,
          onChanged: onChanged,
          onConfirm: onConfirm,
          headDecoration: headDecoration,
          addAllItem: addAllItem,
          theme: Theme.of(context, shadowThemeOnly: true),
          barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
        ));
  }
}

class _PickerRoute<T> extends PopupRoute<T> {
  _PickerRoute({
    this.menu,
    this.menuHeight,
    this.cancelWidget,
    this.commitWidget,
    this.headDecoration,
    this.addAllItem,
    this.title,
    this.backgroundColor,
    this.textColor,
    this.showTitlebar,
    this.initProvince,
    this.initCity,
    this.initTown,
    this.onChanged,
    this.onConfirm,
    this.theme,
    this.barrierLabel,
    RouteSettings settings,
  }) : super(settings: settings);

  final bool showTitlebar;
  final String initProvince, initCity, initTown;
  final AddressCallback onChanged;
  final AddressCallback onConfirm;
  final ThemeData theme;

  final Color backgroundColor; // 背景色
  final Color textColor; // 文字颜色
  final Widget title;
  final Widget menu;
  final double menuHeight;
  final Widget cancelWidget;
  final Widget commitWidget;
  final Decoration headDecoration; // 头部样式
  final bool addAllItem;

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
        initProvince: initProvince,
        initCity: initCity,
        initTown: initTown,
        addAllItem : addAllItem,
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
    this.initProvince,
    this.initCity,
    this.initTown,
    this.addAllItem,
    @required this.route,
    this.onChanged,
  }) : super(key: key);

  final String initProvince, initCity, initTown;
  final AddressCallback onChanged;
  final _PickerRoute route;
  final bool addAllItem;

  @override
  State<StatefulWidget> createState() => _PickerState(this.initProvince, this.initCity, this.initTown, this.addAllItem);
}

class _PickerState extends State<_PickerContentView> {
  String _currentProvince, _currentCity, _currentTown;
  var cities = [];
  var towns = [];
  var provinces = [];

  // 是否显示县级
  bool hasTown = true;
  // 是否添加全部
  final bool addAllItem;

  AnimationController controller;
  Animation<double> animation;

  FixedExtentScrollController provinceScrollCtrl, cityScrollCtrl, townScrollCtrl;

  _PickerState(this._currentProvince, this._currentCity, this._currentTown, this.addAllItem) {
    provinces = Address.provinces;
    hasTown = this._currentTown != null;

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
                  showTitleActions: widget.route.showTitlebar, showMenu: widget.route.menu != null),
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
    Address.addAllItem = addAllItem;
    int pindex = 0;
    int cindex = 0;
    int tindex = 0;
    pindex = provinces.indexWhere((p) => p == _currentProvince);
    pindex = pindex >= 0 ? pindex : 0;
    String selectedProvince = provinces[pindex];
    if (selectedProvince != null) {
      _currentProvince = selectedProvince;

      cities = Address.getCities(selectedProvince);

      cindex = cities.indexWhere((c) => c['name'] == _currentCity);
      cindex = cindex >= 0 ? cindex : 0;
      _currentCity = cities[cindex]['name'];

      // print('longer >>> 外面接到的$cities');

      if (hasTown) {
        towns = Address.getTowns(cities[cindex]['cityCode']);
        tindex = towns.indexWhere((t) => t == _currentTown);
        tindex = tindex >= 0 ? tindex : 0;
        if (towns.length == 0) {
          _currentTown = '';
        } else {
          _currentTown = towns[tindex];
        }
      }
    }

    provinceScrollCtrl = new FixedExtentScrollController(initialItem: pindex);
    cityScrollCtrl = new FixedExtentScrollController(initialItem: cindex);
    townScrollCtrl = new FixedExtentScrollController(initialItem: tindex);
  }

  void _setProvince(int index) {
    String selectedProvince = provinces[index];
    // print('longer >>> index:$index  _currentProvince:$_currentProvince selectedProvince:$selectedProvince ');

    if (_currentProvince != selectedProvince) {
      setState(() {
        _currentProvince = selectedProvince;

        cities = Address.getCities(selectedProvince);
        // print('longer >>> 返回的城市数据：$cities');

        _currentCity = cities[0]['name'];
        cityScrollCtrl.jumpToItem(0);
        if (hasTown) {
          towns = Address.getTowns(cities[0]['cityCode']);
          _currentTown = towns[0];
          townScrollCtrl.jumpToItem(0);
        }
      });

      _notifyLocationChanged();
    }
  }

  void _setCity(int index) {
    index = cities.length > index ? index : 0;
    String selectedCity = cities[index]['name'];
    if (_currentCity != selectedCity) {
      setState(() {
        _currentCity = selectedCity;
        if (hasTown) {
          towns = Address.getTowns(cities[index]['cityCode']);
          _currentTown = towns.isNotEmpty ? towns[0] : '';
          townScrollCtrl.jumpToItem(0);
        }
      });

      _notifyLocationChanged();
    }
  }

  void _setTown(int index) {
    index = towns.length > index ? index : 0;
    String selectedTown = towns[index];
    if (_currentTown != selectedTown) {
      _currentTown = selectedTown;
      _notifyLocationChanged();
    }
  }

  void _notifyLocationChanged() {
    if (widget.onChanged != null) {
      widget.onChanged(_currentProvince, _currentCity, _currentTown);
    }
  }

  double _pickerFontSize(String text) {
    double ratio = hasTown ? 0.0 : 2.0;
    if (text == null || text.length <= 6) {
      return 18.0;
    } else if (text.length < 9) {
      return 16.0 + ratio;
    } else if (text.length < 13) {
      return 12.0 + ratio;
    } else {
      return 10.0 + ratio;
    }
  }

  Widget _renderPickerView() {
    Widget itemView = _renderItemView();

    if (!widget.route.showTitlebar && widget.route.menu == null) {
      return itemView;
    }
    List viewList = <Widget>[];
    if (widget.route.showTitlebar) {
      viewList.add(_titleView());
    }
    if (widget.route.menu != null) {
      viewList.add(widget.route.menu);
    }
    viewList.add(itemView);

    return Column(children: viewList);
  }

  Widget _renderItemView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(
            padding: EdgeInsets.all(8.0),
            height: _pickerHeight,
            color: widget.route.backgroundColor,
            child: CupertinoPicker(
              scrollController: provinceScrollCtrl,
              itemExtent: _pickerItemHeight,
              onSelectedItemChanged: (int index) {
                _setProvince(index);
              },
              children: List.generate(Address.provinces.length, (int index) {
                String text = Address.provinces[index];
                return Container(
                    height: _pickerItemHeight,
                    alignment: Alignment.center,
                    child: Text(text,
                        style: TextStyle(color: widget.route.textColor, fontSize: _pickerFontSize(text)),
                        textAlign: TextAlign.start));
              }),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
              padding: EdgeInsets.all(8.0),
              height: _pickerHeight,
              color: widget.route.backgroundColor,
              child: CupertinoPicker(
                scrollController: cityScrollCtrl,
                itemExtent: _pickerItemHeight,
                onSelectedItemChanged: (int index) {
                  _setCity(index);
                },
                children: List.generate(cities.length, (int index) {
                  String text = cities[index]['name'];
                  return Container(
                    height: _pickerItemHeight,
                    alignment: Alignment.center,
                    child: Text('$text',
                        style: TextStyle(color: widget.route.textColor, fontSize: _pickerFontSize(text)),
                        textAlign: TextAlign.start),
                  );
                }),
              )),
        ),
        hasTown
            ? Expanded(
                flex: 1,
                child: Container(
                    padding: EdgeInsets.all(8.0),
                    height: _pickerHeight,
                    color: widget.route.backgroundColor,
                    child: CupertinoPicker(
                      scrollController: townScrollCtrl,
                      itemExtent: _pickerItemHeight,
                      onSelectedItemChanged: (int index) {
                        _setTown(index);
                      },
                      children: List.generate(towns.length, (int index) {
                        String text = towns[index];
                        return Container(
                          height: _pickerItemHeight,
                          alignment: Alignment.center,
                          child: Text(text,
                              style: TextStyle(color: widget.route.textColor, fontSize: _pickerFontSize(text)),
                              textAlign: TextAlign.start),
                        );
                      }),
                    )),
              )
            : Center()
      ],
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
                widget.route?.onConfirm(_currentProvince, _currentCity, _currentTown);
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
