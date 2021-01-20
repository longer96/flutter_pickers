import 'package:flutter/material.dart';
import 'package:flutter_pickers/address_picker/route/address_picker_route.dart';
import 'package:flutter_pickers/pickers/init_data.dart';
import 'package:flutter_pickers/pickers/route/multiple_picker_route.dart';
import 'package:flutter_pickers/pickers/route/single_picker_route.dart';
import 'package:flutter_pickers/style/default_style.dart';
import 'package:flutter_pickers/style/picker_style.dart';
import 'package:flutter_pickers/time_picker/model/date_mode.dart';
import 'package:flutter_pickers/time_picker/model/pduration.dart';
import 'package:flutter_pickers/time_picker/route/date_picker_route.dart';
import 'package:flutter_pickers/time_picker/model/suffix.dart';

/// [onChanged]   选择器发生变动
/// [onConfirm]   选择器提交
/// [showTitleBar]   是否显示头部 默认：true
/// [menu]   头部和选择器之间的菜单widget,默认空 不显示
/// [menuHeight]   头部和选择器之间的菜单高度  固定高度：36
/// [cancelButton] 取消按钮
/// [commitButton] 确认按钮
/// [title] 头部 中间的标题  默认null 不显示
/// [backgroundColor] 选择器背景色 默认白色
/// [textColor] 选择器文字颜色  默认黑色
/// [headDecoration] 头部Container Decoration 样式
///   默认：BoxDecoration(color: Colors.white)
/// [labelWidget] 自定义单位widget   默认：null
/// [suffix] 后缀   默认：null 不显示
class Pickers {
  /// 单列 通用选择器
  static void showSinglePicker(
    BuildContext context, {
    @required dynamic data,
    dynamic selectData,

    // bool showTitleBar: true,
    // Widget menu,
    // double menuHeight,
    // Widget cancelWidget,
    // Widget commitWidget,
    // Widget labelWidget,
    // String suffix,
    // Widget title,
    // Decoration headDecoration,
    // Color backgroundColor: Colors.white,
    // Color textColor: Colors.black87,

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
          // menu: menu,
          // menuHeight: menuHeight,
          // cancelWidget: cancelWidget,
          // commitWidget: commitWidget,
          // labelWidget: labelWidget,
          // suffix: suffix,
          // title: title,
          // backgroundColor: backgroundColor,
          // textColor: textColor,
          // headDecoration: headDecoration,
          // showTitleBar: showTitleBar,

          pickerStyle: pickerStyle,

          data: data,
          selectData: selectData,
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
    bool showTitleBar: true,
    Widget menu,
    double menuHeight,
    Widget cancelWidget,
    Widget commitWidget,
    Widget title,
    Decoration headDecoration,
    Color backgroundColor: Colors.white,
    Color textColor: Colors.black87,
    MultipleCallback onChanged,
    MultipleCallback onConfirm,
  }) {
    assert(data != null, 'params: data can not be null');
    assert((data is List), 'params : data must List');
    if (selectData != null) {
      assert((data is List), 'params : selectData must List');
    }

    Navigator.push(
        context,
        MultiplePickerRoute(
          data: data,
          selectData: selectData,
          suffix: suffix,
          menu: menu,
          menuHeight: menuHeight,
          cancelWidget: cancelWidget,
          commitWidget: commitWidget,
          title: title,
          backgroundColor: backgroundColor,
          textColor: textColor,
          showTitleBar: showTitleBar,
          onChanged: onChanged,
          onConfirm: onConfirm,
          headDecoration: headDecoration,
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
  /// [showTitleBar]   是否显示头部 默认：true
  /// [menu]   头部和选择器之间的菜单widget,默认空 不显示
  /// [menuHeight]   头部和选择器之间的菜单高度  固定高度：36
  /// [cancelWidget] 取消按钮
  /// [commitWidget] 确认按钮
  /// [title] 头部 中间的标题  默认null 不显示
  /// [backgroundColor] 选择器背景色 默认白色
  /// [textColor] 选择器文字颜色  默认黑色
  /// [headDecoration] 头部Container Decoration 样式
  /// 默认：BoxDecoration(color: backgroundColor)
  /// [addAllItem] 市、区是否添加 '全部' 选项     默认：true
  static void showAddressPicker(
    BuildContext context, {
    bool showTitleBar: true,
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
    Navigator.push(
        context,
        AddressPickerRoute(
          menu: menu,
          menuHeight: menuHeight,
          cancelWidget: cancelWidget,
          commitWidget: commitWidget,
          title: title,
          backgroundColor: backgroundColor,
          textColor: textColor,
          showTitlebar: showTitleBar,
          initProvince: initProvince,
          initCity: initCity,
          initTown: initTown,
          onChanged: onChanged,
          onConfirm: onConfirm,
          headDecoration: headDecoration,
          addAllItem: addAllItem,
          theme: Theme.of(context),
          barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
        ));
  }

  /// 时间选择器
  /// [Suffix] : 每列时间对应的单位  默认：中文常规
  ///   Suffix(years: '年',month: '月');
  /// [initDate] : 初始化时间  默认现在
  ///    PDuration.now();
  ///    PDuration.parse(DateTime.parse('20210139'));
  ///    PDuration(year: 2020,month: 2);
  /// [maxDate] : 最大时间 用法同上  tip: 该限制不与时间关联 只针对单个item 的限制，比如 maxDate>day = 3  minDate>day = 10,那么所有的月份都只显示3-10之间
  /// [minDate] : 最小时间 用法同上
  /// [mode] : 时间选择器所显示样式  16 种时间样式 默认：DateMode.YMD
  static void showDatePicker(
    BuildContext context, {
    DateMode mode: DateMode.YMD,
    PDuration initDate,
    PDuration maxDate,
    PDuration minDate,
    Suffix suffix,

    // style  begin
    bool showTitleBar: true,
    Widget menu,
    double menuHeight,
    Widget cancelWidget,
    Widget commitWidget,
    Widget title,
    Decoration headDecoration,
    Color backgroundColor: Colors.white,
    Color textColor: Colors.black87,
    // style  end

    DateCallback onChanged,
    DateCallback onConfirm,
  }) {
    if (initDate == null) initDate = PDuration.now();
    if (suffix == null) suffix = Suffix.normal();
    if (maxDate == null) maxDate = PDuration(year: 2100);
    if (minDate == null) minDate = PDuration(year: 1900);

    if ([DateMode.MDHMS, DateMode.MDHM, DateMode.MDH, DateMode.MD].contains(mode) && initDate.year == null) {
      print('picker   Tip >>> initDate未设置years，默认设置为now().year');
      initDate.year = DateTime.now().year;
    }

    // 初始化 时间限制 maxDate minDate
    // maxDate.max();
    // minDate.min();

    Navigator.push(
        context,
        DatePickerRoute(
          mode: mode,
          initDate: initDate,
          maxDate: maxDate,
          minDate: minDate,
          suffix: suffix,

          // style  begin
          menu: menu,
          menuHeight: menuHeight,
          cancelWidget: cancelWidget,
          commitWidget: commitWidget,
          title: title,
          backgroundColor: backgroundColor,
          textColor: textColor,
          showTitleBar: showTitleBar,
          headDecoration: headDecoration,
          // style  end

          onChanged: onChanged,
          onConfirm: onConfirm,
          // theme: Theme.of(context, shadowThemeOnly: true),
          theme: Theme.of(context),
          barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
        ));
  }
}
