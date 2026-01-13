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
  List<String> provinces = [];
  ValueNotifier<Map<String, String>> cities = ValueNotifier({});
  ValueNotifier<List<String>> towns = ValueNotifier([]);

  // 是否显示县级
  bool hasTown = true;

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
    _pickerStyle = widget.pickerStyle;
    Address.addAllItem = widget.addAllItem;

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
    int pIndex = 0;
    int cIndex = 0;
    int tIndex = 0;
    pIndex = provinces.indexWhere((p) => p == _currentProvince);
    pIndex = pIndex >= 0 ? pIndex : 0;
    String? selectedProvince = provinces[pIndex];
    _currentProvince = selectedProvince;

    cities.value = Address.getCities(selectedProvince);

    cIndex = cities.value.values.toList().indexOf(_currentCity);
    cIndex = cIndex >= 0 ? cIndex : 0;

    // debugPrint('longer >>> 外面接到的$cities');

    if (hasTown) {
      towns.value = Address.getTowns(cities.value.keys.toList()[cIndex]);
      tIndex = towns.value.indexOf(_currentTown ?? '');
      tIndex = tIndex >= 0 ? tIndex : 0;
      if (towns.value.isEmpty) {
        _currentTown = '';
      } else {
        _currentTown = towns.value[tIndex];
      }
    }

    provinceScrollCtrl = FixedExtentScrollController(initialItem: pIndex);
    cityScrollCtrl = FixedExtentScrollController(initialItem: cIndex);
    townScrollCtrl = FixedExtentScrollController(initialItem: tIndex);
  }

  void _setProvince(int index) {
    String selectedProvince = provinces[index];
    // debugPrint('longer >>> index:$index  _currentProvince:$_currentProvince selectedProvince:$selectedProvince ');

    if (_currentProvince != selectedProvince) {
      _currentProvince = selectedProvince;

      cities.value = Address.getCities(selectedProvince);
      // debugPrint('longer >>> 返回的城市数据：$cities');

      _currentCity = cities.value.values.first;
      cityScrollCtrl.jumpToItem(0);
      if (hasTown) {
        towns.value = Address.getTowns(cities.value.keys.first);
        _currentTown = towns.value[0];
        townScrollCtrl.jumpToItem(0);
      }

      _notifyLocationChanged();
    }
  }

  void _setCity(int index) {
    index = cities.value.length > index ? index : 0;
    String selectedCity = cities.value.values.toList()[index];
    if (_currentCity != selectedCity) {
      _currentCity = selectedCity;
      if (hasTown) {
        towns.value = Address.getTowns(cities.value.keys.toList()[index]);
        _currentTown = towns.value.isNotEmpty ? towns.value[0] : '';
        townScrollCtrl.jumpToItem(0);
      }

      _notifyLocationChanged();
    }
  }

  void _setTown(int index) {
    index = towns.value.length > index ? index : 0;
    String selectedTown = towns.value[index];
    if (_currentTown != selectedTown) {
      _currentTown = selectedTown;
      _notifyLocationChanged();
    }
  }

  void _notifyLocationChanged() {
    widget.route.onChanged?.call(_currentProvince, _currentCity, _currentTown);
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
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: <Widget>[
          SizedBox(width: 8.0),
          Expanded(
            child: PickerColumn(
              scrollController: provinceScrollCtrl,
              pickerStyle: _pickerStyle,
              items: provinces,
              onSettledIndexChanged: (int currentItemIndex) {
                _setProvince(currentItemIndex);
              },
            ),
          ),
          SizedBox(width: 8.0),
          Expanded(
            child: ValueListenableBuilder<Map<String, String>>(
              valueListenable: cities,
              builder: (context, v, _) {
                return PickerColumn(
                  scrollController: cityScrollCtrl,
                  pickerStyle: _pickerStyle,
                  items: v.values.toList(),
                  onSettledIndexChanged: (int index) {
                    _setCity(index);
                  },
                );
              },
            ),
          ),
          SizedBox(width: 8.0),
          if (hasTown) ...[
            Expanded(
              child: ValueListenableBuilder<List<String>>(
                valueListenable: towns,
                builder: (context, v, _) {
                  return PickerColumn(
                    scrollController: townScrollCtrl,
                    pickerStyle: _pickerStyle,
                    items: v.cast<String>(),
                    onSettledIndexChanged: (int index) {
                      _setTown(index);
                    },
                  );
                },
              ),
            ),
            SizedBox(width: 8.0),
          ],
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

class PickerColumn extends StatefulWidget {
  const PickerColumn({
    super.key,
    required this.scrollController,
    required this.pickerStyle,
    required this.items,
    required this.onSettledIndexChanged,
  });

  final FixedExtentScrollController scrollController;
  final PickerStyle pickerStyle;
  final List<String> items;
  final ValueChanged<int> onSettledIndexChanged;

  @override
  State<PickerColumn> createState() => _PickerColumnState();
}

class _PickerColumnState extends State<PickerColumn> {
  int _lastSettledIndex = -1;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollEndNotification>(
      onNotification: (notification) {
        final metrics = notification.metrics;
        if (metrics is FixedExtentMetrics) {
          final int currentItemIndex = metrics.itemIndex;
          if (currentItemIndex != _lastSettledIndex) {
            // https://github.com/flutter/flutter/issues/138536
            // 官方有bug，web端ScrollEndNotification无效会多次触发，currentItemIndex != _lastSettledIndex保证web端逻辑和原来一样
            // 移动端正常触发ScrollEndNotification
            _lastSettledIndex = currentItemIndex;
            widget.onSettledIndexChanged(currentItemIndex);
          }
        }
        return false;
      },
      child: CupertinoPicker.builder(
        scrollController: widget.scrollController,
        selectionOverlay: widget.pickerStyle.itemOverlay,
        itemExtent: widget.pickerStyle.pickerItemHeight,
        onSelectedItemChanged: null,
        childCount: widget.items.length,
        itemBuilder: (_, index) {
          final String text = widget.items[index];
          return FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              text,
              style: TextStyle(
                color: widget.pickerStyle.textColor,
                fontSize: widget.pickerStyle.textSize ?? 18.0,
              ),
            ),
          );
        },
      ),
    );
  }
}
