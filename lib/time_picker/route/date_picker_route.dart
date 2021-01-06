import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pickers/time_picker/model/date_item_model.dart';
import 'package:flutter_pickers/time_picker/model/date_mode.dart';
import 'package:flutter_pickers/time_picker/model/date_time_data.dart';
import 'package:flutter_pickers/time_picker/model/pduration.dart';
import 'package:flutter_pickers/time_picker/model/suffix.dart';

import '../time_utils.dart';

typedef DateCallback(List res);

const double _pickerHeight = 220.0;
const double _pickerTitleHeight = 44.0;
const double _pickerItemHeight = 40.0;
double _pickerMenuHeight = 36.0;

class DatePickerRoute<T> extends PopupRoute<T> {
  DatePickerRoute({
    this.mode,
    this.initDate,
    this.maxDate,
    this.minDate,
    this.suffix,
    this.menu,
    this.menuHeight,
    this.cancelWidget,
    this.commitWidget,
    this.headDecoration,
    this.title,
    this.backgroundColor,
    this.textColor,
    this.showTitleBar,
    this.onChanged,
    this.onConfirm,
    this.theme,
    this.barrierLabel,
    RouteSettings settings,
  }) : super(settings: settings) {
    if (menuHeight != null) _pickerMenuHeight = menuHeight;
  }

  final DateMode mode;
  final PDuration initDate;
  final PDuration maxDate;
  final PDuration minDate;
  final Suffix suffix;

  final bool showTitleBar;
  final DateCallback onChanged;
  final DateCallback onConfirm;
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
        mode: mode,
        initData: initDate,
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
    this.mode,
    this.initData,
    @required this.route,
  }) : super(key: key);

  final DateMode mode;
  final PDuration initData;
  final DatePickerRoute route;

  @override
  State<StatefulWidget> createState() => _PickerState(this.mode, this.initData);
}

class _PickerState extends State<_PickerContentView> {
  // 是否显示 [年月日时分秒]
  DateItemModel dateItemModel;

  // 初始 设置选中的数据
  final PDuration _initData;

  // 选中的数据  用于回传
  PDuration _selectData;

  // 所有item 对应的数据
  DateTimeData _dateTimeData;

  Animation<double> animation;
  Map<String, FixedExtentScrollController> scrollCtrl = {};

  _PickerState(DateMode mode, this._initData) {
    this.dateItemModel = DateItemModel.parse(mode);
    _init();
  }

  _init() {
    scrollCtrl.clear();

    _dateTimeData = DateTimeData();
    int pindex = 0;
    /// 年
    if(dateItemModel.year){
      pindex = 0;
      _dateTimeData.year = TimeUtils.calcYears();
      
      if(_initData.year != null){
        pindex = _dateTimeData.year.indexOf(_initData.year);
        pindex = pindex < 0 ? 0 : pindex;
      }
      scrollCtrl['year'] = FixedExtentScrollController(initialItem: pindex);
    }
    
    /// 月
    // 选中的月 用于之后 day 的计算
    int selectMonth = 1;
    if(dateItemModel.month){
      pindex = 0;
      _dateTimeData.month = TimeUtils.calcMonth();

      if(_initData.month != null){
        pindex = _dateTimeData.month.indexOf(_initData.month);
        pindex = pindex < 0 ? 0 : pindex;
      }
      selectMonth = _dateTimeData.month[pindex];
      scrollCtrl['month'] = FixedExtentScrollController(initialItem: pindex);
    }

    /// 日
    if(dateItemModel.day){
      pindex = 0;
      _dateTimeData.day = TimeUtils.calcDay(_initData.year, selectMonth);

      if(_initData.day != null){
        pindex = _dateTimeData.day.indexOf(_initData.day);
        pindex = pindex < 0 ? 0 : pindex;
      }
      scrollCtrl['day'] = FixedExtentScrollController(initialItem: pindex);
    }

    /// 时   todo
    if(dateItemModel.hour){
      pindex = 0;
      _dateTimeData.hour = TimeUtils.calcDay(_initData.year, selectMonth);

      if(_initData.day != null){
        pindex = _dateTimeData.day.indexOf(_initData.day);
        pindex = pindex < 0 ? 0 : pindex;
      }
      scrollCtrl['day'] = FixedExtentScrollController(initialItem: pindex);
    }



  }

  @override
  void dispose() {
    scrollCtrl.forEach((key, value) {
      value.dispose();
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

  void _setPicker(int index, int selectIndex) {
    var selectedName = _mode[index][selectIndex];

    if (_initData[index].toString() != selectedName.toString()) {
      setState(() {
        _initData[index] = selectedName;
      });
      _notifyLocationChanged();
    }
  }

  void _notifyLocationChanged() {
    if (widget.route.onChanged != null) {
      widget.route.onChanged(_initData);
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

    pickerList = List.generate(this._mode.length, (index) => pickerView(index)).toList();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
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
      flex: 1,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: CupertinoPicker(
          scrollController: scrollCtrl[position],
          itemExtent: _pickerItemHeight,
          onSelectedItemChanged: (int selectIndex) => _setPicker(position, selectIndex),
          children: List.generate(_mode[position].length, (int index) {
            String text = _mode[position][index].toString();
            return Container(
                alignment: Alignment.center,
                child: Text(text,
                    style: TextStyle(color: widget.route.textColor, fontSize: _pickerFontSize(text)),
                    textAlign: TextAlign.start));
          }),
        ),
      ),
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
                widget.route?.onConfirm(_initData);
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
