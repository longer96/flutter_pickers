import 'package:flutter/material.dart';

// abstract class PickerStyle {
//   ///  是否显示头部（选择器以上的控件） 默认：true
//   bool get showTitleBar;
//
//   ///  头部和选择器之间的菜单widget,默认空 不显示
//   Widget get menu;
//
//   ///  头部 中间的标题  默认SizedBox() 不显示
//   Widget get title;
//
//   /// [pickerHeight]  选择器下面 picker 的整体高度  固定高度：220.0
//   double get pickerHeight;
//
//   /// [pickerTitleHeight]  选择器上面 title 确认、取消的整体高度  固定高度：44.0
//   double get pickerTitleHeight;
//
//   /// [pickerItemHeight]  选择器每个被选中item的高度：40.0
//   double get pickerItemHeight;
//
//   /// [menuHeight]   头部和选择器之间的菜单高度  固定高度：36.0
//   double get menuHeight;
//
//   ///  取消按钮
//   Widget get cancelButton;
//
//   ///  确认按钮
//   Widget get commitButton;
//
//   /// 选择器背景色 默认白色
//   Color get backgroundColor;
//
//   /// 选择器文字颜色  默认黑色
//   // Color getTextColor();
//   Color get textColor;
//
//   /// [headDecoration] 头部Container Decoration 样式
//   ///  null 默认：BoxDecoration(color: Colors.white)
//   Decoration get headDecoration;
//
//   /// [labelWidget] 自定义单位widget   默认：null
//   /// SinglePickerRoute 选择器可用
//   Widget get labelWidget;
// }

/// 基础样式
class PickerStyle {
  BuildContext _context;

  bool _showTitleBar;
  Widget _menu;

  double _pickerHeight;
  double _pickerTitleHeight;
  double _pickerItemHeight;
  double _menuHeight;

  Widget _cancelButton;
  Widget _commitButton;
  Widget _labelWidget;
  Widget _title;
  Decoration _headDecoration;
  Color _backgroundColor;
  Color _textColor;

  PickerStyle(
      {BuildContext context,
      bool showTitleBar,
      Widget menu,
      double pickerHeight,
      double pickerTitleHeight,
      double pickerItemHeight,
      double menuHeight,
      Widget cancelButton,
      Widget commitButton,
      Widget labelWidget,
      Widget title,
      Decoration headDecoration,
      Color backgroundColor,
      Color textColor}) {
    this._context = context;
    this._showTitleBar = showTitleBar;
    this._menu = menu;

    this._pickerHeight = pickerHeight;
    this._pickerTitleHeight = pickerTitleHeight;
    this._pickerItemHeight = pickerItemHeight;
    this._menuHeight = menuHeight;

    this._cancelButton = cancelButton;
    this._commitButton = commitButton;
    this._labelWidget = labelWidget;
    this._title = title;
    this._headDecoration = headDecoration;
    this._backgroundColor = backgroundColor;
    this._textColor = textColor;
  }


  set context(BuildContext value) {
    _context = value;
  }

  set menuHeight(double value) {
    _menuHeight = value;
  }

  set menu(Widget value) {
    _menu = value;
  }

  set pickerHeight(double value) {
    _pickerHeight = value;
  }

  set pickerTitleHeight(double value) {
    _pickerTitleHeight = value;
  }

  set pickerItemHeight(double value) {
    _pickerItemHeight = value;
  }

  set cancelButton(Widget value) {
    _cancelButton = value;
  }

  set commitButton(Widget value) {
    _commitButton = value;
  }

  set labelWidget(Widget value) {
    _labelWidget = value;
  }

  set title(Widget value) {
    _title = value;
  }

  set headDecoration(Decoration value) {
    _headDecoration = value;
  }

  set backgroundColor(Color value) {
    _backgroundColor = value;
  }

  set textColor(Color value) {
    _textColor = value;
  }

  set showTitleBar(bool value) {
    _showTitleBar = value;
  }

  BuildContext get context => this._context;

  Color get backgroundColor => this._backgroundColor ?? Colors.white;

  Decoration get headDecoration => this._headDecoration ?? BoxDecoration(color: Colors.white);

  Widget get labelWidget => this._labelWidget;

  Widget get menu => this._menu;

  double get menuHeight => this._menuHeight ?? 36.0;

  double get pickerHeight => this._pickerHeight ?? 220.0;

  double get pickerItemHeight => this._pickerItemHeight ?? 40.0;

  double get pickerTitleHeight => this._pickerTitleHeight ?? 44.0;

  bool get showTitleBar => this._showTitleBar ?? true;

  Color get textColor => this._textColor ?? Colors.black87;

  Widget get title => this._title ?? SizedBox();

  Widget get commitButton => getCommitButton();

  Widget get cancelButton => getCancelButton();

  Widget getCommitButton() {
    return this._commitButton ??
        Container(
          // todo
          height: _pickerTitleHeight,
          alignment: Alignment.center,
          padding: const EdgeInsets.only(left: 12, right: 22),
          child: Text('确定', style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16.0)),
        );
  }

  Widget getCancelButton() {
    return this._cancelButton ??
        Container(
          alignment: Alignment.center,
          // todo
          height: _pickerTitleHeight,
          padding: const EdgeInsets.only(left: 22, right: 12),
          child: Text('取消', style: TextStyle(color: Theme.of(context).unselectedWidgetColor, fontSize: 16.0)),
        );
  }
}
