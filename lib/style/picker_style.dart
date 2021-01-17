import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

abstract class PickerStyle {
  ///  是否显示头部（选择器以上的控件） 默认：true
  bool get showTitleBar;

  ///  头部和选择器之间的菜单widget,默认空 不显示
  Widget get menu;

  ///  头部 中间的标题  默认null 不显示
  Widget get title;

  /// [pickerHeight]  选择器下面 picker 的整体高度  固定高度：220.0
  double get pickerHeight;

  /// [pickerTitleHeight]  选择器上面 title 确认、取消的整体高度  固定高度：44.0
  double get pickerTitleHeight;

  /// [pickerItemHeight]  选择器每个被选中item的高度：40.0
  double get pickerItemHeight;

  /// [menuHeight]   头部和选择器之间的菜单高度  固定高度：36.0
  double get menuHeight;

  ///  取消按钮
  Widget get cancelButton;

  ///  确认按钮
  Widget get commitButton;

  /// 选择器背景色 默认白色
  Color get backgroundColor;

  /// 选择器文字颜色  默认黑色
  // Color getTextColor();
  Color get textColor;

  /// [headDecoration] 头部Container Decoration 样式
  ///  null 默认：BoxDecoration(color: Colors.white)
  Decoration get headDecoration;

  /// [labelWidget] 自定义单位widget   默认：null
  /// SinglePickerRoute 选择器可用
  Widget get labelWidget;
}

// /// 默认样式
class DefaultStyle extends PickerStyle {
  final BuildContext context;
  bool dark = false;
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

  DefaultStyle(this.context,
      {bool dark,
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
    this.dark = dark;
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

  @override
  Color get backgroundColor => this._backgroundColor ?? Colors.white;

  @override
  Decoration get headDecoration => this._headDecoration ?? BoxDecoration(color: Colors.white);

  @override
  Widget get labelWidget => this._labelWidget;

  @override
  Widget get menu => this._menu;

  @override
  double get menuHeight => this._menuHeight ?? 36.0;

  @override
  double get pickerHeight => this._pickerHeight ?? 220.0;

  @override
  double get pickerItemHeight => this._pickerItemHeight ?? 40.0;

  @override
  double get pickerTitleHeight => this._pickerTitleHeight ?? 44.0;

  @override
  bool get showTitleBar => this._showTitleBar ?? true;

  @override
  Color get textColor => this._textColor ?? Colors.black87;

  @override
  Widget get title => this._title;

  @override
  Widget get commitButton => getCommitButton();

  @override
  Widget get cancelButton => getCancelButton();




  getCommitButton() {
    return this._commitButton ??
        Container(
          height: _pickerTitleHeight,
          alignment: Alignment.center,
          padding: const EdgeInsets.only(left: 12, right: 22),
          child: Text('确定', style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16.0)),
        );
  }

  getCancelButton() {
    return this._cancelButton ??
        Container(
          alignment: Alignment.center,
          height: _pickerTitleHeight,
          padding: const EdgeInsets.only(left: 22, right: 12),
          child: Text('取消', style: TextStyle(color: Theme.of(context).unselectedWidgetColor, fontSize: 16.0)),
        );
  }
}
