import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pickers/style/picker_style.dart';
import 'package:flutter_pickers/time_picker/model/date_item_model.dart';
import 'package:flutter_pickers/time_picker/model/date_mode.dart';
import 'package:flutter_pickers/time_picker/model/date_time_data.dart';
import 'package:flutter_pickers/time_picker/model/date_type.dart';
import 'package:flutter_pickers/time_picker/model/pduration.dart';
import 'package:flutter_pickers/time_picker/model/suffix.dart';

import '../time_utils.dart';

typedef DateCallback(PDuration res);

class DatePickerRoute<T> extends PopupRoute<T> {
  DatePickerRoute({
    this.mode,
    required this.initDate,
    this.pickerStyle,
    required this.maxDate,
    required this.minDate,
    this.suffix,
    this.onChanged,
    this.onConfirm,
    this.onCancel,
    this.theme,
    this.barrierLabel,
    RouteSettings? settings,
  }) : super(settings: settings);

  final DateMode? mode;
  late final PDuration initDate;
  late final PDuration maxDate;
  late final PDuration minDate;
  final Suffix? suffix;
  final ThemeData? theme;
  final DateCallback? onChanged;
  final DateCallback? onConfirm;
  final Function(bool isCancel)? onCancel;
  final PickerStyle? pickerStyle;

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

  AnimationController? _animationController;

  @override
  AnimationController createAnimationController() {
    assert(_animationController == null);
    _animationController =
        BottomSheet.createAnimationController(navigator!.overlay!);
    return _animationController!;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    Widget bottomSheet = MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: _PickerContentView(
        mode: mode,
        initData: initDate,
        maxDate: maxDate,
        minDate: minDate,
        pickerStyle: pickerStyle!,
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
    this.mode,
    required this.initData,
    required this.pickerStyle,
    required this.maxDate,
    required this.minDate,
    required this.route,
  }) : super(key: key);

  final DateMode? mode;
  late final PDuration initData;
  late final DatePickerRoute route;
  late final PickerStyle pickerStyle;

  // 限制时间
  late final PDuration maxDate;
  late final PDuration minDate;

  @override
  State<StatefulWidget> createState() => _PickerState(
      this.mode, this.initData, this.maxDate, this.minDate, this.pickerStyle);
}

class _PickerState extends State<_PickerContentView> {
  late final PickerStyle _pickerStyle;

  // 是否显示 [年月日时分秒]
  late DateItemModel _dateItemModel;

  // 初始 设置选中的数据
  late final PDuration _initSelectData;

  // 选中的数据  用于回传
  late PDuration _selectData;

  // 所有item 对应的数据
  late DateTimeData _dateTimeData;

  // 限制时间
  late final PDuration maxDate;
  late final PDuration minDate;

  Animation<double>? animation;
  Map<DateType, FixedExtentScrollController> scrollCtrl = {};

  // 选择器 高度  单独提出来，用来解决修改数据 不及时更新的BUG
  late double pickerItemHeight;

  _PickerState(DateMode? mode, this._initSelectData, this.maxDate, this.minDate,
      this._pickerStyle) {
    this._dateItemModel = DateItemModel.parse(mode!);
    this.pickerItemHeight = _pickerStyle.pickerItemHeight;
    _init();
  }

  _init() {
    scrollCtrl.clear();

    _dateTimeData = DateTimeData();
    int index = 0; // 初始选中值  Index
    _selectData = PDuration();

    /// minDate 和 maxDate 都初始化了，可以省略很多空判断，直接比较选中值 是否相等 _selectData.month == minDate.month
    /// -------年
    if (_dateItemModel.year) {
      index = 0;
      _dateTimeData.year =
          TimeUtils.calcYears(begin: minDate.year!, end: maxDate.year!);

      if (_initSelectData.year != null) {
        index = _dateTimeData.year.indexOf(_initSelectData.year);
        index = index < 0 ? 0 : index;
      }
      _selectData.year = _dateTimeData.year[index];
      scrollCtrl[DateType.Year] =
          FixedExtentScrollController(initialItem: index);
    }

    /// ------月
    // 选中的月 用于之后 day 的计算
    int selectMonth = 1;
    if (_dateItemModel.month) {
      index = 0;
      int begin = 1;
      int end = 12;
      // 限制区域
      if (intNotEmpty(minDate.month) && _selectData.year == minDate.year) {
        begin = minDate.month!;
      }
      if (intNotEmpty(maxDate.month) && _selectData.year == maxDate.year) {
        end = maxDate.month!;
      }

      _dateTimeData.month = TimeUtils.calcMonth(begin: begin, end: end);

      if (_initSelectData.month != null) {
        index = _dateTimeData.month.indexOf(_initSelectData.month);
        index = index < 0 ? 0 : index;
      }
      selectMonth = _dateTimeData.month[index];
      _selectData.month = selectMonth;
      scrollCtrl[DateType.Month] =
          FixedExtentScrollController(initialItem: index);
    }

    /// -------日   （有日肯定有 年月数据）
    if (_dateItemModel.day) {
      index = 0;
      int begin = 1;
      int end = 31;
      // 限制区域
      if (intNotEmpty(minDate.day) || intNotEmpty(maxDate.day)) {
        if (_selectData.year == minDate.year &&
            _selectData.month == minDate.month) {
          begin = minDate.day!;
        }
        if (_selectData.year == maxDate.year &&
            _selectData.month == maxDate.month) {
          end = maxDate.day!;
        }
      }

      _dateTimeData.day = TimeUtils.calcDay(_initSelectData.year!, selectMonth,
          begin: begin, end: end);

      if (_initSelectData.day != null) {
        index = _dateTimeData.day.indexOf(_initSelectData.day);
        index = index < 0 ? 0 : index;
      }
      _selectData.day = _dateTimeData.day[index];
      scrollCtrl[DateType.Day] =
          FixedExtentScrollController(initialItem: index);
    }

    /// ---------时
    if (_dateItemModel.hour) {
      index = 0;
      int begin = 0;
      int end = 23;
      // 限制区域
      if (intNotEmpty(minDate.hour)) {
        begin = minDate.hour!;
      }
      if (intNotEmpty(maxDate.hour)) {
        end = maxDate.hour!;
      }

      _dateTimeData.hour = TimeUtils.calcHour(begin: begin, end: end);

      if (_initSelectData.hour != null) {
        index = _dateTimeData.hour.indexOf(_initSelectData.hour);
        index = index < 0 ? 0 : index;
      }
      _selectData.hour = _dateTimeData.hour[index];
      scrollCtrl[DateType.Hour] =
          FixedExtentScrollController(initialItem: index);
    }

    /// ---------分
    if (_dateItemModel.minute) {
      index = 0;
      int begin = 0;
      int end = 59;
      // 限制区域
      if (intNotEmpty(minDate.minute) || intNotEmpty(maxDate.minute)) {
        if (_dateItemModel.hour) {
          // 如果有上级 还有时，要根据时再判断
          if (_selectData.hour == minDate.hour) {
            begin = minDate.minute!;
          }
          if (_selectData.hour == maxDate.hour) {
            end = maxDate.minute!;
          }
        } else {
          // 上级没有时间限制 直接取
          if (intNotEmpty(minDate.minute)) {
            begin = minDate.minute!;
          }
          if (intNotEmpty(maxDate.minute)) {
            end = maxDate.minute!;
          }
        }
      }

      _dateTimeData.minute = TimeUtils.calcMinAndSecond(begin: begin, end: end);

      if (_initSelectData.minute != null) {
        index = _dateTimeData.minute.indexOf(_initSelectData.minute);
        index = index < 0 ? 0 : index;
      }
      _selectData.minute = _dateTimeData.minute[index];
      scrollCtrl[DateType.Minute] =
          FixedExtentScrollController(initialItem: index);
    }

    /// --------秒
    if (_dateItemModel.second) {
      index = 0;
      int begin = 0;
      int end = 59;
      // 限制区域
      if (intNotEmpty(minDate.second) || intNotEmpty(maxDate.second)) {
        if (_dateItemModel.hour && _dateItemModel.minute) {
          // 如果有上级 还有时 分，要根据时分再判断
          if (_selectData.hour == minDate.hour &&
              _selectData.minute == minDate.minute) {
            begin = minDate.second!;
          }
          if (_selectData.hour == maxDate.hour &&
              _selectData.minute == maxDate.minute) {
            end = maxDate.second!;
          }
        } else if (_dateItemModel.minute) {
          /// 上级没有时，只有分限制
          if (_selectData.minute == minDate.minute) {
            begin = minDate.second!;
          }
          if (_selectData.minute == maxDate.minute) {
            end = maxDate.second!;
          }
        } else {
          /// 上级没有时间限制 直接取
          if (intNotEmpty(minDate.second)) {
            begin = minDate.second!;
          }
          if (intNotEmpty(maxDate.second)) {
            end = maxDate.second!;
          }
        }
      }

      _dateTimeData.second = TimeUtils.calcMinAndSecond(begin: begin, end: end);

      if (_initSelectData.second != null) {
        index = _dateTimeData.second.indexOf(_initSelectData.second);
        index = index < 0 ? 0 : index;
      }
      _selectData.second = _dateTimeData.second[index];
      scrollCtrl[DateType.Second] =
          FixedExtentScrollController(initialItem: index);
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
        animation: widget.route.animation!,
        builder: (BuildContext context, Widget? child) {
          return ClipRect(
            child: CustomSingleChildLayout(
              delegate: _BottomPickerLayout(
                  widget.route.animation!.value, _pickerStyle),
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

  void _setPicker(DateType dateType, int selectIndex) {
    // 得到新的选中的数据
    var selectValue = _dateTimeData.getListByName(dateType)[selectIndex];
    // 更新选中数据
    _selectData.setSingle(dateType, selectValue);

    switch (dateType) {
      case DateType.Year:
        _setYear();
        break;
      case DateType.Month:
        _setMonth();
        break;
      case DateType.Day:
        break;
      case DateType.Hour:
        _setHour();
        break;
      case DateType.Minute:
        _setMinute();
        break;
      case DateType.Second:
        break;
    }
    _notifyLocationChanged();
  }

  // -------------------- set   begin ------------
  void _setYear() {
    // 可能造成 月 日 list的改变
    if (_dateItemModel.month) {
      // 月的数据是否需要更新
      bool updateMonth = false;
      bool updateDay = false;

      /// 如果只有月
      int beginMonth = 1;
      int endMonth = 12;
      // 限制区域
      if (intNotEmpty(minDate.month) && _selectData.year == minDate.year) {
        beginMonth = minDate.month!;
      }
      if (intNotEmpty(maxDate.month) && _selectData.year == maxDate.year) {
        endMonth = maxDate.month!;
      }

      var resultMonth = TimeUtils.calcMonth(begin: beginMonth, end: endMonth);

      int jumpToIndexMonth = 0;

      if (!listEquals(_dateTimeData.month, resultMonth)) {
        //可能 选中的月份 由于设置了新数据后没有了
        // 小于不用考虑 会进else
        if (_selectData.month! > resultMonth.last) {
          jumpToIndexMonth = resultMonth.length - 1;
        } else {
          jumpToIndexMonth = resultMonth.indexOf(_selectData.month);
        }
        jumpToIndexMonth = jumpToIndexMonth < 0 ? 0 : jumpToIndexMonth;
        _selectData.month = resultMonth[jumpToIndexMonth];
        updateMonth = true;
      }

      /// 还有 日
      int jumpToIndexDay = 0;
      // 新的day 数据
      var resultDay;
      if (_dateItemModel.day) {
        int beginDay = 1;
        int endDay = 31;
        // 限制区域
        if (intNotEmpty(minDate.day) || intNotEmpty(maxDate.day)) {
          if (_selectData.year == minDate.year &&
              _selectData.month == minDate.month) {
            beginDay = minDate.day!;
          }
          if (_selectData.year == maxDate.year &&
              _selectData.month == maxDate.month) {
            endDay = maxDate.day!;
          }
        }
        resultDay = TimeUtils.calcDay(_selectData.year!, _selectData.month!,
            begin: beginDay, end: endDay);

        if (!listEquals(_dateTimeData.day, resultDay)) {
          //可能 选中的年 月份 由于设置了新数据后没有了
          // 小于不用考虑 会进else
          if (_selectData.day! > resultDay.last) {
            jumpToIndexDay = resultDay.length - 1;
          } else {
            jumpToIndexDay = resultDay.indexOf(_selectData.day);
          }
          jumpToIndexDay = jumpToIndexDay < 0 ? 0 : jumpToIndexDay;
          _selectData.day = resultDay[jumpToIndexDay];
          updateDay = true;
        }
      }

      if (updateMonth || updateDay) {
        setState(() {
          if (updateMonth) {
            _dateTimeData.month = resultMonth;
            scrollCtrl[DateType.Month]?.jumpToItem(jumpToIndexMonth);
          }
          if (updateDay) {
            _dateTimeData.day = resultDay;
            scrollCtrl[DateType.Day]?.jumpToItem(jumpToIndexDay);
          }

          /// FIX:https://github.com/flutter/flutter/issues/22999
          pickerItemHeight =
              _pickerStyle.pickerItemHeight - Random().nextDouble() / 100000000;
        });
      }
    }
  }

  void _setMonth() {
    // 可能造成 日 list的改变
    bool updateDay = false;
    int jumpToIndexDay = 0;
    // 新的day 数据
    var resultDay;
    if (_dateItemModel.day) {
      int beginDay = 1;
      int endDay = 31;
      // 限制区域
      if (intNotEmpty(minDate.day) || intNotEmpty(maxDate.day)) {
        if (_selectData.year == minDate.year &&
            _selectData.month == minDate.month) {
          beginDay = minDate.day!;
        }
        if (_selectData.year == maxDate.year &&
            _selectData.month == maxDate.month) {
          endDay = maxDate.day!;
        }
      }
      resultDay = TimeUtils.calcDay(_selectData.year!, _selectData.month!,
          begin: beginDay, end: endDay);

      if (!listEquals(_dateTimeData.day, resultDay)) {
        //可能 选中的年 月份 由于设置了新数据后没有了
        // 小于不用考虑 会进else
        if (_selectData.day! > resultDay.last) {
          jumpToIndexDay = resultDay.length - 1;
        } else {
          jumpToIndexDay = resultDay.indexOf(_selectData.day);
        }
        jumpToIndexDay = jumpToIndexDay < 0 ? 0 : jumpToIndexDay;
        _selectData.day = resultDay[jumpToIndexDay];
        updateDay = true;
      }
    }
    if (updateDay) {
      setState(() {
        _dateTimeData.day = resultDay;
        scrollCtrl[DateType.Day]?.jumpToItem(jumpToIndexDay);

        /// FIX:https://github.com/flutter/flutter/issues/22999
        pickerItemHeight =
            _pickerStyle.pickerItemHeight - Random().nextDouble() / 100000000;
      });
    }
  }

  void _setHour() {
    // 可能造成 分 秒 list的改变
    if (_dateItemModel.minute) {
      // 月的数据是否需要更新
      bool updateMinute = false;
      bool updateSecond = false;

      /// 如果只有分
      int beginMinute = 0;
      int endMinute = 59;
      // 限制区域
      if (intNotEmpty(minDate.minute) && _selectData.hour == minDate.hour) {
        beginMinute = minDate.minute!;
      }
      if (intNotEmpty(maxDate.minute) && _selectData.hour == maxDate.hour) {
        endMinute = maxDate.minute!;
      }

      var resultMinute =
          TimeUtils.calcMinAndSecond(begin: beginMinute, end: endMinute);

      int jumpToIndexMinute = 0;

      if (!listEquals(_dateTimeData.month, resultMinute)) {
        //可能 选中的时间 由于设置了新数据后没有了
        // 小于不用考虑 会进else
        if (_selectData.minute! > resultMinute.last) {
          jumpToIndexMinute = resultMinute.length - 1;
        } else {
          jumpToIndexMinute = resultMinute.indexOf(_selectData.minute);
        }
        jumpToIndexMinute = jumpToIndexMinute < 0 ? 0 : jumpToIndexMinute;
        _selectData.minute = resultMinute[jumpToIndexMinute];
        updateMinute = true;
      }

      /// 还有 秒
      int jumpToIndexSecond = 0;
      // 新的day 数据
      var resultSecond;
      if (_dateItemModel.second) {
        int beginSecond = 0;
        int endSecond = 59;
        // 限制区域
        if (intNotEmpty(minDate.second) || intNotEmpty(maxDate.second)) {
          if (_selectData.hour == minDate.hour &&
              _selectData.minute == minDate.minute) {
            beginSecond = minDate.second!;
          }
          if (_selectData.hour == maxDate.hour &&
              _selectData.minute == maxDate.minute) {
            endSecond = maxDate.second!;
          }
        }
        resultSecond =
            TimeUtils.calcMinAndSecond(begin: beginSecond, end: endSecond);

        if (!listEquals(_dateTimeData.second, resultSecond)) {
          //可能 选中的时 分 由于设置了新数据后没有了
          // 小于不用考虑 会进else
          if (_selectData.second! > resultSecond.last) {
            jumpToIndexSecond = resultSecond.length - 1;
          } else {
            jumpToIndexSecond = resultSecond.indexOf(_selectData.second);
          }
          jumpToIndexSecond = jumpToIndexSecond < 0 ? 0 : jumpToIndexSecond;
          _selectData.second = resultSecond[jumpToIndexSecond];
          updateSecond = true;
        }
      }

      if (updateMinute || updateSecond) {
        setState(() {
          if (updateMinute) {
            _dateTimeData.minute = resultMinute;
            scrollCtrl[DateType.Minute]?.jumpToItem(jumpToIndexMinute);
          }
          if (updateSecond) {
            _dateTimeData.second = resultSecond;
            scrollCtrl[DateType.Second]?.jumpToItem(jumpToIndexSecond);
          }

          /// FIX:https://github.com/flutter/flutter/issues/22999
          pickerItemHeight =
              _pickerStyle.pickerItemHeight - Random().nextDouble() / 100000000;
        });
      }
    }
  }

  void _setMinute() {
    // 可能造成 秒 list的改变
    bool updateSecond = false;
    int jumpToIndexSecond = 0;
    // 新的day 数据
    var resultSecond;
    if (_dateItemModel.second) {
      int beginSecond = 0;
      int endSecond = 59;
      // 限制区域
      if (intNotEmpty(minDate.second) || intNotEmpty(maxDate.second)) {
        if (_dateItemModel.hour) {
          // 如果上面还有 时
          if (_selectData.hour == minDate.hour &&
              _selectData.minute == minDate.minute) {
            beginSecond = minDate.second!;
          }
          if (_selectData.hour == maxDate.hour &&
              _selectData.minute == maxDate.minute) {
            endSecond = maxDate.second!;
          }
        } else {
          // 没有时，分秒
          if (_selectData.minute == minDate.minute) {
            beginSecond = minDate.second!;
          }
          if (_selectData.minute == maxDate.minute) {
            endSecond = maxDate.second!;
          }
        }
      }
      resultSecond =
          TimeUtils.calcMinAndSecond(begin: beginSecond, end: endSecond);

      if (!listEquals(_dateTimeData.second, resultSecond)) {
        //可能 选中的分 由于设置了新数据后没有了
        // 小于不用考虑 会进else
        if (_selectData.second! > resultSecond.last) {
          jumpToIndexSecond = resultSecond.length - 1;
        } else {
          jumpToIndexSecond = resultSecond.indexOf(_selectData.second);
        }
        jumpToIndexSecond = jumpToIndexSecond < 0 ? 0 : jumpToIndexSecond;
        _selectData.second = resultSecond[jumpToIndexSecond];
        updateSecond = true;
      }
    }
    if (updateSecond) {
      setState(() {
        _dateTimeData.second = resultSecond;
        scrollCtrl[DateType.Second]?.jumpToItem(jumpToIndexSecond);

        /// FIX:https://github.com/flutter/flutter/issues/22999
        pickerItemHeight =
            _pickerStyle.pickerItemHeight - Random().nextDouble() / 100000000;
      });
    }
  }

  // -------------------- set   end ------------

  void _notifyLocationChanged() {
    if (widget.route.onChanged != null) {
      widget.route.onChanged!(_selectData);
    }
  }

  double _pickerFontSize(String text) {
    if (text == '') return 18.0;

    if (_dateItemModel.length == 6 && (text.length > 4 && text.length <= 6)) {
      return 16.0;
    }

    if (text.length <= 6) {
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
    List<Widget> pickerList = [];
    if (_dateItemModel.year) pickerList.add(pickerView(DateType.Year));
    if (_dateItemModel.month) pickerList.add(pickerView(DateType.Month));
    if (_dateItemModel.day) pickerList.add(pickerView(DateType.Day));
    if (_dateItemModel.hour) pickerList.add(pickerView(DateType.Hour));
    if (_dateItemModel.minute) pickerList.add(pickerView(DateType.Minute));
    if (_dateItemModel.second) pickerList.add(pickerView(DateType.Second));

    return Container(
      height: _pickerStyle.pickerHeight,
      color: _pickerStyle.backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: pickerList,
      ),
    );
  }

  ///  CupertinoPicker.builder
  Widget pickerView(DateType dateType) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: CupertinoPicker.builder(
          /// key ：年月拼接 就不会重复了 fixme
          /// 最好别使用key 会生成新的widget
          /// 官方的bug : https://github.com/flutter/flutter/issues/22999
          /// 临时方法 通过修改height
          scrollController: scrollCtrl[dateType],
          itemExtent: pickerItemHeight,
          selectionOverlay: _pickerStyle.itemOverlay,
          onSelectedItemChanged: (int selectIndex) =>
              _setPicker(dateType, selectIndex),
          childCount: _dateTimeData.getListByName(dateType).length,
          itemBuilder: (_, index) {
            String text =
                '${_dateTimeData.getListByName(dateType)[index]}${widget.route.suffix?.getSingle(dateType)}';
            return Align(
                alignment: Alignment.center,
                child: Text(text,
                    style: TextStyle(
                        color: _pickerStyle.textColor,
                        fontSize: _pickerFontSize(text)),
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
                  widget.route.onConfirm!(_selectData);
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
