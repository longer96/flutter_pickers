import 'dart:math';

import 'package:flutter/cupertino.dart';
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
    this.initDate,
    this.pickerStyle,
    this.maxDate,
    this.minDate,
    this.suffix,
    this.onChanged,
    this.onConfirm,
    this.theme,
    this.barrierLabel,
    RouteSettings settings,
  }) : super(settings: settings);

  final DateMode mode;
  final PDuration initDate;
  final PDuration maxDate;
  final PDuration minDate;
  final Suffix suffix;
  final ThemeData theme;
  final DateCallback onChanged;
  final DateCallback onConfirm;
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
        mode: mode,
        initData: initDate,
        maxDate: maxDate,
        minDate: minDate,
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
    this.mode,
    this.initData,
    this.pickerStyle,
    this.maxDate,
    this.minDate,
    @required this.route,
  }) : super(key: key);

  final DateMode mode;
  final PDuration initData;
  final DatePickerRoute route;
  final PickerStyle pickerStyle;

  // 限制时间
  final PDuration maxDate;
  final PDuration minDate;

  @override
  State<StatefulWidget> createState() =>
      _PickerState(this.mode, this.initData, this.maxDate, this.minDate, this.pickerStyle);
}

class _PickerState extends State<_PickerContentView> {
  final PickerStyle _pickerStyle;

  // 是否显示 [年月日时分秒]
  DateItemModel _dateItemModel;

  // 初始 设置选中的数据
  final PDuration _initSelectData;

  // 选中的数据  用于回传
  PDuration _selectData;

  // 所有item 对应的数据
  DateTimeData _dateTimeData;

  // 限制时间
  final PDuration maxDate;
  final PDuration minDate;

  Animation<double> animation;
  Map<DateType, FixedExtentScrollController> scrollCtrl = {};

  // 选择器 高度  单独提出来，用来解决修改数据 不及时更新的BUG
  double pickerItemHeight;

  _PickerState(DateMode mode, this._initSelectData, this.maxDate, this.minDate, this._pickerStyle) {
    this._dateItemModel = DateItemModel.parse(mode);
    this.pickerItemHeight = _pickerStyle.pickerItemHeight;
    _init();
  }

  _init() {
    scrollCtrl.clear();

    _dateTimeData = DateTimeData();
    int index = 0; // 初始选中值  Index
    _selectData = PDuration();

    /// -------年
    if (_dateItemModel.year) {
      index = 0;
      _dateTimeData.year = TimeUtils.calcYears(begin: minDate.year, end: maxDate.year);

      if (_initSelectData.year != null) {
        index = _dateTimeData.year.indexOf(_initSelectData.year);
        index = index < 0 ? 0 : index;
      }
      _selectData.year = _dateTimeData.year[index];
      scrollCtrl[DateType.Year] = FixedExtentScrollController(initialItem: index);
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
        begin = minDate.month;
      }
      if (intNotEmpty(maxDate.month) && _selectData.year == maxDate.year) {
        end = maxDate.month;
      }

      _dateTimeData.month = TimeUtils.calcMonth(begin: begin, end: end);

      if (_initSelectData.month != null) {
        index = _dateTimeData.month.indexOf(_initSelectData.month);
        index = index < 0 ? 0 : index;
      }
      selectMonth = _dateTimeData.month[index];
      _selectData.month = selectMonth;
      scrollCtrl[DateType.Month] = FixedExtentScrollController(initialItem: index);
    }

    /// -------日   （有日肯定有 年月数据）
    if (_dateItemModel.day) {
      index = 0;
      int begin = 1;
      int end = 31;
      // 限制区域
      if (intNotEmpty(minDate.day) && intNotEmpty(minDate.month)) {
        if (_selectData.year == minDate.year && _selectData.month == minDate.month) {
          begin = minDate.day;
        }
        if (_selectData.year == maxDate.year && _selectData.month == maxDate.month) {
          end = maxDate.day;
        }
      }

      _dateTimeData.day = TimeUtils.calcDay(_initSelectData.year, selectMonth, begin: begin, end: end);

      if (_initSelectData.day != null) {
        index = _dateTimeData.day.indexOf(_initSelectData.day);
        index = index < 0 ? 0 : index;
      }
      _selectData.day = _dateTimeData.day[index];
      scrollCtrl[DateType.Day] = FixedExtentScrollController(initialItem: index);
    }

    /// ---------时
    if (_dateItemModel.hour) {
      index = 0;
      int begin = 0;
      int end = 23;
      // 限制区域
      if (intNotEmpty(minDate.hour)) {
        begin = minDate.hour;
      }
      if (intNotEmpty(maxDate.hour)) {
        end = maxDate.hour;
      }

      _dateTimeData.hour = TimeUtils.calcHour(begin: begin, end: end);

      if (_initSelectData.hour != null) {
        index = _dateTimeData.hour.indexOf(_initSelectData.hour);
        index = index < 0 ? 0 : index;
      }
      _selectData.hour = _dateTimeData.hour[index];
      scrollCtrl[DateType.Hour] = FixedExtentScrollController(initialItem: index);
    }

    /// ---------分
    if (_dateItemModel.minute) {
      index = 0;
      int begin = 0;
      int end = 59;
      // 限制区域
      if (intNotEmpty(minDate.minute) || intNotEmpty(maxDate.minute)) {
        if (_dateItemModel.hour) {
          // 如果有上级 还有时间，要根据时间再判断
          if (_selectData.hour == minDate.hour) {
            begin = minDate.minute;
          }
          if (_selectData.hour == maxDate.hour) {
            end = maxDate.minute;
          }
          print('longer >>> _selectData.hour${_selectData.hour}  minDate.hour: ${minDate.hour}');
        } else {
          // 上级没有时间限制 直接取
          if (intNotEmpty(minDate.minute)) {
            begin = minDate.minute;
          }
          if (intNotEmpty(maxDate.minute)) {
            end = maxDate.minute;
          }
        }
      }

      _dateTimeData.minute = TimeUtils.calcMinAndSecond(begin: begin, end: end);

      if (_initSelectData.minute != null) {
        index = _dateTimeData.minute.indexOf(_initSelectData.minute);
        index = index < 0 ? 0 : index;
      }
      _selectData.minute = _dateTimeData.minute[index];
      scrollCtrl[DateType.Minute] = FixedExtentScrollController(initialItem: index);
    }

    /// --------秒
    if (_dateItemModel.second) {
      index = 0;
      int begin = 0;
      int end = 59;
      // 限制区域
      if (intNotEmpty(minDate.second) || intNotEmpty(maxDate.second)) {
        if (_dateItemModel.hour && _dateItemModel.minute) {
          // 如果有上级 还有时间，要根据时间再判断
          if (_selectData.hour == minDate.hour && _selectData.minute == minDate.minute) {
            begin = minDate.second;
          }
          if (_selectData.hour == maxDate.hour && _selectData.minute == maxDate.minute) {
            end = maxDate.second;
          }
        } else {
          // 上级没有时间限制 直接取
          if (intNotEmpty(minDate.second)) {
            begin = minDate.second;
          }
          if (intNotEmpty(maxDate.second)) {
            end = maxDate.second;
          }
        }
      }

      _dateTimeData.second = TimeUtils.calcMinAndSecond(begin: begin, end: end);

      if (_initSelectData.second != null) {
        index = _dateTimeData.second.indexOf(_initSelectData.second);
        index = index < 0 ? 0 : index;
      }
      _selectData.second = _dateTimeData.second[index];
      scrollCtrl[DateType.Second] = FixedExtentScrollController(initialItem: index);
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
              delegate: _BottomPickerLayout(widget.route.animation.value, _pickerStyle),
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
        _setYear(selectIndex);
        break;
      case DateType.Month:
        break;
      case DateType.Day:
        break;
      case DateType.Hour:
        break;
      case DateType.Minute:
        break;
      case DateType.Second:
        break;
    }
    _notifyLocationChanged();
  }

  // -------------------- set   begin ------------
  void _setYear(int selectIndex) {
    // 可能造成 月 日 list的改变
    if (_dateItemModel.month) {
      if (!_dateItemModel.day) {
        /// 如果只有月
        int begin = 1;
        int end = 12;
        // 限制区域
        if (intNotEmpty(minDate.month) && _selectData.year == minDate.year) {
          begin = minDate.month;
        }
        if (intNotEmpty(maxDate.month) && _selectData.year == maxDate.year) {
          end = maxDate.month;
        }

        var resultMonth = TimeUtils.calcMonth(begin: begin, end: end);

        if (resultMonth.length != _dateTimeData.month.length ||
            _dateTimeData.month.first != resultMonth.first ||
            _dateTimeData.month.last != resultMonth.last) {
          //可能 选中的月份 由于设置了新数据后没有了
          int jumpToIndex = 0;
          // 小于不用考虑
          if (_selectData.month > resultMonth.last) {
            jumpToIndex = resultMonth.length - 1;
          } else {
            jumpToIndex = resultMonth.indexOf(_selectData.month);
          }
          print('longer >>> _selectData.month${_selectData.month}  jumpToIndex:${jumpToIndex}');
          jumpToIndex = jumpToIndex < 0 ? 0 : jumpToIndex;
          _selectData.month = resultMonth[jumpToIndex];
          scrollCtrl[DateType.Month]?.jumpToItem(jumpToIndex);

          setState(() {
            _dateTimeData.month = resultMonth;
            pickerItemHeight = _pickerStyle.pickerItemHeight - Random().nextDouble() / 100000000;
          });
        }
      } else {
        // 有月 和 日
        int begin = 1;
        int end = 12;
        // 限制区域
        if (intNotEmpty(minDate.month) && _selectData.year == minDate.year) {
          begin = minDate.month;
        }
        if (intNotEmpty(maxDate.month) && _selectData.year == maxDate.year) {
          end = maxDate.month;
        }

        var resultMonth = TimeUtils.calcMonth(begin: begin, end: end);

        if (resultMonth.length != _dateTimeData.month.length ||
            _dateTimeData.month.first != resultMonth.first ||
            _dateTimeData.month.last != resultMonth.last) {
          //可能 选中的月份 由于设置了新数据后没有了
          int jumpToIndex = 0;
          // 小于不用考虑 会进else
          if (_selectData.month > resultMonth.last) {
            jumpToIndex = resultMonth.length - 1;
          } else {
            jumpToIndex = resultMonth.indexOf(_selectData.month);
          }
          jumpToIndex = jumpToIndex < 0 ? 0 : jumpToIndex;
          _selectData.month = resultMonth[jumpToIndex];
          scrollCtrl[DateType.Month]?.jumpToItem(jumpToIndex);

          setState(() {
            _dateTimeData.month = resultMonth;
            pickerItemHeight = _pickerStyle.pickerItemHeight - Random().nextDouble() / 100000000;
          });
        }

        // 计算日 长度
        // 有月 和 日
        int beginDay = 1;
        int endDay = 31;
        // 限制区域
        if (intNotEmpty(minDate.month) && intNotEmpty(maxDate.month)) {
          if (_selectData.year == minDate.year && _selectData.month == minDate.minute) {
            beginDay = minDate.month;
          }
          if (_selectData.year == maxDate.year && _selectData.month == maxDate.minute) {
            endDay = minDate.month;
          }
        }
        var resultDay = TimeUtils.calcDay(_selectData.year, _selectData.month, begin: beginDay, end: endDay);

        if (resultDay.length != _dateTimeData.day.length ||
            _dateTimeData.day.first != resultDay.first ||
            _dateTimeData.day.last != resultDay.last) {
          //可能 选中的年 月份 由于设置了新数据后没有了
          int jumpToIndex = 0;
          // 小于不用考虑 会进else
          if (_selectData.day > resultDay.last) {
            jumpToIndex = resultDay.length - 1;
          } else {
            jumpToIndex = resultDay.indexOf(_selectData.day);
          }
          jumpToIndex = jumpToIndex < 0 ? 0 : jumpToIndex;
          _selectData.day = resultDay[jumpToIndex];

          scrollCtrl[DateType.Day]?.jumpToItem(jumpToIndex);

          setState(() {
            _dateTimeData.day = resultDay;
            pickerItemHeight = _pickerStyle.pickerItemHeight - Random().nextDouble() / 100000000;
          });
        }
      }
    }
  }

  // 检查是否需要更新 Day picker data
  // void _checkUpdateDay(DateType dateType, int selectIndex) {
  //   // 如果是月或者年 可能会带动日的变化
  //   if (dateType == DateType.Year || dateType == DateType.Month) {
  //     // 年 月
  //     var selectYear;
  //     var selectMonth;
  //
  //     if (dateType == DateType.Year) {
  //       selectYear = _dateTimeData.year[selectIndex];
  //       // 月 Picker 肯定不为空
  //       selectMonth = _selectData.month;
  //     } else if (dateType == DateType.Month) {
  //       selectMonth = _dateTimeData.month[selectIndex];
  //
  //       // 年 Picker 可能为空，如果为空，我们从_initData 里面取数据
  //       if (_dateItemModel.year) {
  //         selectYear = _selectData.year;
  //       } else {
  //         selectYear = _initSelectData.year;
  //       }
  //     }
  //
  //     var resultDays = TimeUtils.calcDay(selectYear, selectMonth);
  //
  //     /// key ：年月拼接 就不会重复了 fixme
  //     /// 最好别使用key 会生成新的widget
  //     /// 官方的bug : https://github.com/flutter/flutter/issues/22999
  //     /// 临时方法 通过修改height
  //     // 如果天数一样不用更新
  //     if (resultDays.length != _dateTimeData.day.length) {
  //       //可能 选中的天数大于 新的一个月的长度，设置选中在最后一天 fixme
  //       if (_selectData.day > resultDays[resultDays.length - 1]) {
  //         scrollCtrl[DateType.Day]?.jumpToItem(resultDays.length - 1);
  //       }
  //
  //       setState(() {
  //         _dateTimeData.day = resultDays;
  //         pickerItemHeight = _pickerStyle.pickerItemHeight - Random().nextDouble() / 100000000;
  //       });
  //     }
  //   }
  // }

  // -------------------- set   end ------------

  void _notifyLocationChanged() {
    if (widget.route.onChanged != null) {
      widget.route.onChanged(_selectData);
    }
  }

  double _pickerFontSize(String text) {
    if (text == null) return 18.0;

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
          onSelectedItemChanged: (int selectIndex) => _setPicker(dateType, selectIndex),
          childCount: _dateTimeData.getListByName(dateType).length,
          itemBuilder: (_, index) {
            String text = '${_dateTimeData.getListByName(dateType)[index]}${widget.route.suffix.getSingle(dateType)}';
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

  /// 可能设置了时间区间  我们的筛选一下
  ///  月日 需要根据上级进行判断
  ///  如果上级有选项需要进行判断
  List filteData(DateType dateType) {
    List data = List.from(_dateTimeData.getListByName(dateType));

    int min = minDate.getSingle(dateType);
    int max = maxDate.getSingle(dateType);

    // 如果都为0 相当于没有设置限制 直接返回
    if (min == 0 && max == 0) return data;

    // 查询出索引
    int begin = data.indexOf(min);
    begin = begin < 0 ? 0 : begin;

    int end = data.indexOf(max);
    end = end < 0 ? 0 : end;

    // 如果都为0 相当于没有设置限制 直接返回
    if (begin == 0 && end == 0) return data;

    if (dateType == DateType.Year) {
      // 年 是多少直接取多少
      if (begin != 0 && end == 0) {
        return data.sublist(begin);
      } else {
        return data.sublist(begin, end + 1);
      }
    }

    return [];
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
