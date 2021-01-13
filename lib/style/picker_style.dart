import 'package:flutter/widgets.dart';

abstract class PickerStyle {
  ///  是否显示头部（选择器以上的控件） 默认：true
  bool showTitleBar();

  ///  头部和选择器之间的菜单widget,默认空 不显示
  Widget menu();

  ///  头部 中间的标题  默认null 不显示
  Widget setTitle();

  /// [menuHeight]   头部和选择器之间的菜单高度  固定高度：36
  double menuHeight();

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
  Widget labelWidget() {
    return null;
  }

  /// [label] 单位   默认：null 不显示
  String label();

  Widget  get Title => setTitle();

}

/// 默认样式
class DefaultStyle extends PickerStyle {
  bool dark = false;
  // bool showTitleBar;
  // Widget menu;
  // double menuHeight;
  // Widget cancelWidget;
  // Widget commitWidget;
  // Widget labelWidget;
  // String label;
  // Widget title;
  // Decoration headDecoration;
  // Color backgroundColor;
  // Color textColor;

  DefaultStyle.dark() {
    this.dark = true;
  }
}
