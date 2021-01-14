import 'package:flutter/widgets.dart';

abstract class PickerStyle {
  ///  是否显示头部（选择器以上的控件） 默认：true
  bool getShowTitleBar();

  ///  头部和选择器之间的菜单widget,默认空 不显示
  Widget getMenu();

  ///  头部 中间的标题  默认null 不显示
  Widget getTitle();

  /// [pickerHeight]  选择器下面 picker 的整体高度  固定高度：220.0
  double getPickerHeight() {
    return 220.0;
  }

  /// [pickerTitleHeight]  选择器上面 title 确认、取消的整体高度  固定高度：44.0
  double getPickerTitleHeight() {
    return 44.0;
  }

  /// [pickerItemHeight]  选择器上面 title 确认、取消的整体高度  固定高度：44.0
  double getPickerItemHeight() {
    return 44.0;
  }

  /// [menuHeight]   头部和选择器之间的菜单高度  固定高度：36.0
  double getMenuHeight() {
    return 36.0;
  }

  ///  取消按钮
  Widget getCancelWidget();

  ///  确认按钮
  Widget getCommitWidget();

  /// 选择器背景色 默认白色
  Color getBackgroundColor();

  /// 选择器文字颜色  默认黑色
  Color getTextColor();

  /// [headDecoration] 头部Container Decoration 样式
  ///  null 默认：BoxDecoration(color: Colors.white)
  Decoration getHeadDecoration();

  /// [labelWidget] 自定义单位widget   默认：null
  /// SinglePickerRoute 选择器可用
  Widget getLabelWidget() {
    return null;
  }

  bool get showTitleBar => getShowTitleBar();

  Widget get menu => getMenu();

  Widget get title => getTitle();

  double get pickerHeight => getPickerHeight() ?? 220.0;

  double get pickerTitleHeight => getPickerTitleHeight() ?? 44.0;

  double get pickerItemHeight => getPickerItemHeight() ?? 40.0;

  double get menuHeight => getMenuHeight() ?? 36.0;

  Widget get cancelWidget => getCancelWidget();

  Widget get commitWidget => getCommitWidget();

  Color get backgroundColor => getBackgroundColor();

  Color get textColor => getTextColor();

  Decoration get headDecoration => getHeadDecoration();

  Widget get labelWidget => getLabelWidget();
}

// /// 默认样式
class DefaultStyle extends PickerStyle {
  bool dark = false;
  bool showTitleBar;
  Widget menu;

  double pickerHeight;
  double pickerTitleHeight;
  double pickerItemHeight;
  double menuHeight;

  Widget cancelWidget;
  Widget commitWidget;
  Widget labelWidget;
  Widget title;
  Decoration headDecoration;
  Color backgroundColor;
  Color textColor;

  DefaultStyle(
      {this.dark = false,
      this.showTitleBar = true,
      this.menu,
      this.menuHeight = 36.0,
      this.cancelWidget,
      this.commitWidget,
      this.labelWidget,
      this.title,
      this.headDecoration,
      this.backgroundColor,
      this.textColor}) {}

  DefaultStyle.dark() {
    this.dark = true;
  }

  @override
  Color getBackgroundColor() {
    return backgroundColor;
  }

  @override
  Widget getCancelWidget() {
    return cancelWidget;
  }

  @override
  Widget getCommitWidget() {
    return commitWidget;
  }

  @override
  Decoration getHeadDecoration() {
    return headDecoration;
  }

  @override
  Widget getMenu() {
    return menu;
  }

  @override
  bool getShowTitleBar() {
    return showTitleBar;
  }

  @override
  Color getTextColor() {
    return textColor;
  }

  @override
  Widget getTitle() {
    return title;
  }

  @override
  double getMenuHeight() {
    return menuHeight;
  }

  @override
  double getPickerHeight() {
    return pickerHeight;
  }

  @override
  double getPickerTitleHeight() {
    return pickerTitleHeight;
  }

  @override
  double getPickerItemHeight() {
    return pickerItemHeight;
  }

  @override
  Widget getLabelWidget() {
    return labelWidget;
  }
}
