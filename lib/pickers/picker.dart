import 'package:flutter/material.dart';
import 'package:flutter_pickers/pickers/init_data.dart';
import 'package:flutter_pickers/pickers/route_page/link_multiple_picker.dart';
import 'package:flutter_pickers/pickers/route_page/multiple_picker.dart';
import 'package:flutter_pickers/pickers/route_page/single_picker.dart';

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
///   默认：BoxDecoration(color: Colors.white)
/// [labelWidget] 自定义单位widget   默认：null
/// [label] 单位   默认：null 不显示
class Picker {
  /// 单列 通用选择器
  static void showSinglePicker(
    BuildContext context, {
    @required dynamic data,
    dynamic selectData,
    bool showTitleBar: true,
    Widget menu,
    double menuHeight,
    Widget cancelWidget,
    Widget commitWidget,
    Widget labelWidget,
    String label,
    Widget title,
    Decoration headDecoration,
    Color backgroundColor: Colors.white,
    Color textColor: Colors.black87,
    SingleCallback onChanged,
    SingleCallback onConfirm,
  }) {
    assert(data != null, 'params: data can not be null');
    assert((data is List) || (data is PickerDataType), 'params : data must List or PickerDataType');

    Navigator.push(
        context,
        SinglePickerRoute(
          menu: menu,
          menuHeight: menuHeight,
          cancelWidget: cancelWidget,
          commitWidget: commitWidget,
          labelWidget: labelWidget,
          label: label,
          title: title,
          backgroundColor: backgroundColor,
          textColor: textColor,
          showTitleBar: showTitleBar,
          data: data,
          selectData: selectData,
          onChanged: onChanged,
          onConfirm: onConfirm,
          headDecoration: headDecoration,
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
    if(selectData != null){
      assert((data is List), 'params : selectData must List');
    }

    Navigator.push(
        context,
        MultiplePickerRoute(
          menu: menu,
          menuHeight: menuHeight,
          cancelWidget: cancelWidget,
          commitWidget: commitWidget,
          title: title,
          backgroundColor: backgroundColor,
          textColor: textColor,
          showTitleBar: showTitleBar,
          data: data,
          selectData: selectData,
          onChanged: onChanged,
          onConfirm: onConfirm,
          headDecoration: headDecoration,
          // theme: Theme.of(context, shadowThemeOnly: true),
          theme: Theme.of(context),
          barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
        ));
  }

  /// 通用 双列选择器（联动），目前只支持2列联动
  // static void showLinkMultiplePicker(
  //     BuildContext context, {
  //       @required dynamic data,
  //       @required dynamic selectData,
  //       bool showTitleBar: true,
  //       Widget menu,
  //       double menuHeight,
  //       Widget cancelWidget,
  //       Widget commitWidget,
  //       Widget title,
  //       Decoration headDecoration,
  //       Color backgroundColor: Colors.white,
  //       Color textColor: Colors.black87,
  //       MultipleCallback onChanged,
  //       MultipleCallback onConfirm,
  //     }) {
  // }

}
