import 'package:flutter/material.dart';
import 'package:flutter_pickers/address_picker/route/address_picker_route.dart';
import 'package:flutter_pickers/more_pickers/init_data.dart';
import 'package:flutter_pickers/more_pickers/route/multiple_picker_route.dart';
import 'package:flutter_pickers/more_pickers/route/single_picker_route.dart';
import 'package:flutter_pickers/style/default_style.dart';
import 'package:flutter_pickers/style/picker_style.dart';
import 'package:flutter_pickers/time_picker/model/date_mode.dart';
import 'package:flutter_pickers/time_picker/model/pduration.dart';
import 'package:flutter_pickers/time_picker/route/date_picker_route.dart';
import 'package:flutter_pickers/time_picker/model/suffix.dart';

import 'time_picker/model/date_item_model.dart';

/// [onChanged]   选择器发生变动
/// [onConfirm]   选择器提交
/// [suffix] 后缀   默认：null 不显示
class Pickers {
  /// 单列 通用选择器
  static void showSinglePicker(
    BuildContext context, {
    @required dynamic data,
    dynamic selectData,
    PickerStyle pickerStyle,
    SingleCallback onChanged,
    SingleCallback onConfirm,
  }) {
    assert(data != null, 'params: data can not be null');
    assert((data is List) || (data is PickerDataType), 'params : data must List or PickerDataType');

    if (pickerStyle == null) {
      pickerStyle = DefaultPickerStyle();
    }
    if (pickerStyle.context == null) {
      pickerStyle.context = context;
    }

    Navigator.push(
        context,
        SinglePickerRoute(
          data: data,
          selectData: selectData,
          pickerStyle: pickerStyle,
          onChanged: onChanged,
          onConfirm: onConfirm,
          // theme: Theme.of(context, shadowThemeOnly: true),
          theme: Theme.of(context),
          barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
        ));
  }

  /// 通用 多列选择器
  static void showMultiplePicker(
    BuildContext context, {
    @required dynamic data,
    @required dynamic selectData,
    dynamic suffix,
    PickerStyle pickerStyle,
    MultipleCallback onChanged,
    MultipleCallback onConfirm,
  }) {
    assert(data != null, 'params: data can not be null');
    assert((data is List), 'params : data must List');
    if (selectData != null) {
      assert((data is List), 'params : selectData must List');
    }

    if (pickerStyle == null) {
      pickerStyle = DefaultPickerStyle();
    }
    if (pickerStyle.context == null) {
      pickerStyle.context = context;
    }

    Navigator.push(
        context,
        MultiplePickerRoute(
          data: data,
          selectData: selectData,
          suffix: suffix,
          pickerStyle: pickerStyle,
          onChanged: onChanged,
          onConfirm: onConfirm,
          // theme: Theme.of(context, shadowThemeOnly: true),
          theme: Theme.of(context),
          barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
        ));
  }

  /// 自定义 地区选择器
  /// [initProvince] 初始化 省
  /// [initCity]    初始化 市
  /// [initTown]    初始化 区
  /// [onChanged]   选择器发生变动
  /// [onConfirm]   选择器提交
  /// [addAllItem] 市、区是否添加 '全部' 选项     默认：true
  static void showAddressPicker(
    BuildContext context, {
    PickerStyle pickerStyle,
    String initProvince: '',
    String initCity: '',
    String initTown,
    bool addAllItem: true,
    AddressCallback onChanged,
    AddressCallback onConfirm,
  }) {
    if (pickerStyle == null) {
      pickerStyle = DefaultPickerStyle();
    }
    if (pickerStyle.context == null) {
      pickerStyle.context = context;
    }

    Navigator.push(
        context,
        AddressPickerRoute(
          pickerStyle: pickerStyle,
          initProvince: initProvince,
          initCity: initCity,
          initTown: initTown,
          onChanged: onChanged,
          onConfirm: onConfirm,
          addAllItem: addAllItem,
          theme: Theme.of(context),
          barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
        ));
  }

  /// 时间选择器
  /// [Suffix] : 每列时间对应的单位  默认：中文常规  Suffix(years: '年',month: '月');
  /// [selectDate] : 初始化选中时间  默认现在
  ///    PDuration.now();
  ///    PDuration.parse(DateTime.parse('20210139'));
  ///    PDuration(year: 2020,month: 2);
  /// [maxDate] : 最大时间 用法同上
  ///     tip: 当只有单列数据，该限制不产生关联 只针对单列item限制，比如 maxDate>day = 3  minDate>day = 10,那么所有的月份都只显示3-10之间
  /// [minDate] : 最小时间 用法同上
  /// [mode] : 时间选择器所显示样式  16 种时间样式 默认：DateMode.YMD
  static void showDatePicker(
    BuildContext context, {
    DateMode mode: DateMode.YMD,
    PDuration selectDate,
    PDuration maxDate,
    PDuration minDate,
    Suffix suffix,
    PickerStyle pickerStyle,
    DateCallback onChanged,
    DateCallback onConfirm,
  }) {
    if (pickerStyle == null) {
      pickerStyle = DefaultPickerStyle();
    }
    if (pickerStyle.context == null) {
      pickerStyle.context = context;
    }

    if (selectDate == null) selectDate = PDuration.now();
    if (suffix == null) suffix = Suffix.normal();

    // 解析是否有对应数据
    DateItemModel dateItemModel = DateItemModel.parse(mode);

    /// 如果有年item ，必须限制
    if (maxDate == null && dateItemModel.year) {
      maxDate = PDuration(year: 2100);
    }
    if (minDate == null && dateItemModel.year) {
      minDate = PDuration(year: 1900);
    }

    if ([DateMode.MDHMS, DateMode.MDHM, DateMode.MDH, DateMode.MD].contains(mode) && intEmpty(selectDate.year)) {
      print('picker  Tip >>> initDate未设置years，默认设置为now().year');
      selectDate.year = DateTime.now().year;
    }
    if(dateItemModel.day) {
      assert(minDate.year > 1582, 'minDate Year must > 1582');
    }


    Navigator.push(
        context,
        DatePickerRoute(
          mode: mode,
          initDate: selectDate,
          maxDate: maxDate ?? PDuration(),
          minDate: minDate ?? PDuration(),
          suffix: suffix,
          pickerStyle: pickerStyle,
          onChanged: onChanged,
          onConfirm: onConfirm,
          // theme: Theme.of(context, shadowThemeOnly: true),
          theme: Theme.of(context),
          barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
        ));
  }
}
