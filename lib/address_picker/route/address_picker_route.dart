import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
class AddressPickerRoute<T> extends PopupRoute<T> {
  AddressPickerRoute({
    required this.addAllItem,
    required this.pickerStyle,
    required this.initProvince,
    required this.initCity,
    this.initTown,
    this.onChanged,
    this.onConfirm,
    this.onCancel,
    this.theme,
    this.barrierLabel,
    super.settings,
  });

  late final String initProvince, initCity;
  final String? initTown;
  final AddressCallback? onChanged;
  final AddressCallback? onConfirm;
  final Function(bool isCancel)? onCancel;
  final ThemeData? theme;
  final bool addAllItem;

  late final PickerStyle pickerStyle;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  @override
  bool get barrierDismissible => true;

  @override
  bool didPop(T? result) {
    if (result == null) {
      onCancel?.call(false);
    } else if (!(result as bool)) {
      onCancel?.call(true);
    }
    return super.didPop(result);
  }

  @override
  final String? barrierLabel;

  @override
  Color get barrierColor => Colors.black54;

  AnimationController? _animationController;

  @override
  AnimationController createAnimationController() {
    assert(_animationController == null);
    _animationController = BottomSheet.createAnimationController(
      navigator!.overlay!,
    );
    return _animationController!;
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    Widget bottomSheet = MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: PickerContentView(
        initProvince: initProvince,
        initCity: initCity,
        initTown: initTown,
        addAllItem: addAllItem,
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

class PickerContentView extends StatefulWidget {
  const PickerContentView({
    super.key,
    required this.initProvince,
    required this.initCity,
    this.initTown,
    required this.pickerStyle,
    required this.addAllItem,
    required this.route,
  });

  final String initProvince, initCity;
  final String? initTown;
  final AddressPickerRoute route;
  final bool addAllItem;
  final PickerStyle pickerStyle;

  @override
  State<PickerContentView> createState() => _PickerState();
}

class _PickerState extends State<PickerContentView> {
  late final PickerStyle _pickerStyle;
  late String _currentProvince, _currentCity;
  String? _currentTown;
  var cities = [];
  var towns = [];
  var provinces = [];

  // 是否显示县级
  bool hasTown = true;

  // 是否添加全部
  late final bool addAllItem;

  AnimationController? controller;
  Animation<double>? animation;

  late FixedExtentScrollController provinceScrollCtrl,
      cityScrollCtrl,
      townScrollCtrl;

  @override
  void initState() {
    super.initState();
    _currentProvince = widget.initProvince;
    _currentCity = widget.initCity;
    _currentTown = widget.initTown;
    addAllItem = widget.addAllItem;
    _pickerStyle = widget.pickerStyle;

    provinces = Address.provinces;
    hasTown = _currentTown != null;
    _init();
  }

  @override
  void dispose() {
    provinceScrollCtrl.dispose();
    cityScrollCtrl.dispose();
    townScrollCtrl.dispose();

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
              delegate: _BottomPickerLayout(
                widget.route.animation!.value,
                _pickerStyle,
              ),
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

  void _init() {
    Address.addAllItem = addAllItem;
    int pindex = 0;
    int cindex = 0;
    int tindex = 0;
    pindex = provinces.indexWhere((p) => p == _currentProvince);
    pindex = pindex >= 0 ? pindex : 0;
    String? selectedProvince = provinces[pindex];
    if (selectedProvince != null) {
      _currentProvince = selectedProvince;

      cities = Address.getCities(selectedProvince);

      cindex = cities.indexWhere((c) => c['name'] == _currentCity);
      cindex = cindex >= 0 ? cindex : 0;
      _currentCity = cities[cindex]['name'];

      // debugPrint('longer >>> 外面接到的$cities');

      if (hasTown) {
        towns = Address.getTowns(cities[cindex]['cityCode']);
        tindex = towns.indexWhere((t) => t == _currentTown);
        tindex = tindex >= 0 ? tindex : 0;
        if (towns.isEmpty) {
          _currentTown = '';
        } else {
          _currentTown = towns[tindex];
        }
      }
    }

    provinceScrollCtrl = FixedExtentScrollController(initialItem: pindex);
    cityScrollCtrl = FixedExtentScrollController(initialItem: cindex);
    townScrollCtrl = FixedExtentScrollController(initialItem: tindex);
  }

  void _setProvince(int index) {
    String selectedProvince = provinces[index];
    // debugPrint('longer >>> index:$index  _currentProvince:$_currentProvince selectedProvince:$selectedProvince ');

    if (_currentProvince != selectedProvince) {
      setState(() {
        _currentProvince = selectedProvince;

        cities = Address.getCities(selectedProvince);
        // debugPrint('longer >>> 返回的城市数据：$cities');

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
    widget.route.onChanged?.call(_currentProvince, _currentCity, _currentTown);
  }

  double _pickerFontSize(String text) {
    double ratio = hasTown ? 0.0 : 2.0;
    if (text.length <= 6) {
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
    return Container(
      height: _pickerStyle.pickerHeight,
      color: _pickerStyle.backgroundColor,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoPicker.builder(
                scrollController: provinceScrollCtrl,
                selectionOverlay: _pickerStyle.itemOverlay,
                itemExtent: _pickerStyle.pickerItemHeight,
                onSelectedItemChanged: (int index) {
                  _setProvince(index);
                },
                childCount: Address.provinces.length,
                itemBuilder: (_, index) {
                  String text = Address.provinces[index];
                  return Align(
                    alignment: Alignment.center,
                    child: Text(
                      text,
                      style: TextStyle(
                        color: _pickerStyle.textColor,
                        fontSize:
                            _pickerStyle.textSize ?? _pickerFontSize(text),
                      ),
                      textAlign: TextAlign.start,
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: CupertinoPicker.builder(
                scrollController: cityScrollCtrl,
                selectionOverlay: _pickerStyle.itemOverlay,
                itemExtent: _pickerStyle.pickerItemHeight,
                onSelectedItemChanged: (int index) {
                  _setCity(index);
                },
                childCount: cities.length,
                itemBuilder: (_, index) {
                  String text = cities[index]['name'];
                  return Align(
                    alignment: Alignment.center,
                    child: Text(
                      text,
                      style: TextStyle(
                        color: _pickerStyle.textColor,
                        fontSize: _pickerStyle.textSize ?? _pickerFontSize(text),
                      ),
                      textAlign: TextAlign.start,
                    ),
                  );
                },
              ),
            ),
          ),
          hasTown
              ? Expanded(
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  child: CupertinoPicker.builder(
                    scrollController: townScrollCtrl,
                    selectionOverlay: _pickerStyle.itemOverlay,
                    itemExtent: _pickerStyle.pickerItemHeight,
                    onSelectedItemChanged: (int index) {
                      _setTown(index);
                    },
                    childCount: towns.length,
                    itemBuilder: (_, index) {
                      String text = towns[index];
                      return Align(
                        alignment: Alignment.center,
                        child: Text(
                          text,
                          style: TextStyle(
                            color: _pickerStyle.textColor,
                            fontSize: _pickerStyle.textSize ?? _pickerFontSize(text),
                          ),
                          textAlign: TextAlign.start,
                        ),
                      );
                    },
                  ),
                ),
              )
              : SizedBox(),
        ],
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
            child: _pickerStyle.cancelButton,
          ),

          /// 标题
          Expanded(child: _pickerStyle.title),

          /// 确认按钮
          InkWell(
            onTap: () {
              widget.route.onConfirm?.call(
                _currentProvince,
                _currentCity,
                _currentTown,
              );
              Navigator.pop(context, true);
            },
            child: _pickerStyle.commitButton,
          ),
        ],
      ),
    );
  }
}

class _BottomPickerLayout extends SingleChildLayoutDelegate {
  _BottomPickerLayout(this.progress, this.pickerStyle);

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
      maxHeight: maxHeight,
    );
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
