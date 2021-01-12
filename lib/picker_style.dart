import 'package:flutter/widgets.dart';

abstract class PickerStyle {
  ///  是否显示头部（选择器以上的控件） 默认：true
  bool showTitleBar() {
    return true;
  }

  ///  头部和选择器之间的菜单widget,默认空 不显示
  Widget menu();

  ///  头部 中间的标题  默认null 不显示
  Widget title();

  /// [menuHeight]   头部和选择器之间的菜单高度  固定高度：36
  double menuHeight(double height) {
    return height;
  }

  ///  取消按钮
  Widget cancelWidget();

  ///  确认按钮
  Widget commitWidget();

  /// 选择器背景色 默认白色
  Color backgroundColor();

  /// 选择器文字颜色  默认黑色
  Color textColor();

  /// [headDecoration] 头部Container Decoration 样式
  ///  null 默认：BoxDecoration(color: Colors.white)
  Decoration headDecoration();

  /// [labelWidget] 自定义单位widget   默认：null
  /// 有的选择器不需要
  Widget labelWidget();

  /// [label] 单位   默认：null 不显示
  String label();
}

class PickerStyle1 extends PickerStyle {
  @override
  double menuHeight(double height) {
    return 36.0;
  }

  @override
  Widget menu() {
    // TODO: implement getMenu
    throw UnimplementedError();
  }

  @override
  Widget cancelWidget() {
    // TODO: implement cancelWidget
    throw UnimplementedError();
  }

  @override
  Widget commitWidget() {
    // TODO: implement commitWidget
    throw UnimplementedError();
  }

  @override
  Widget title() {
    // TODO: implement title
    throw UnimplementedError();
  }

  @override
  Color backgroundColor() {
    // TODO: implement backgroundColor
    throw UnimplementedError();
  }

  @override
  Decoration headDecoration() {
    // TODO: implement headDecoration
    throw UnimplementedError();
  }

  @override
  String label() {
    // TODO: implement label
    throw UnimplementedError();
  }

  @override
  Widget labelWidget() {
    // TODO: implement labelWidget
    throw UnimplementedError();
  }

  @override
  Color textColor() {
    // TODO: implement textColor
    throw UnimplementedError();
  }
}
