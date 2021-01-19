import 'package:flutter/material.dart';
import 'package:flutter_pickers/style/picker_style.dart';

class NoTitleStyle extends PickerStyle {
  NoTitleStyle(BuildContext context) : super(context) {
    this.showTitleBar =  false;
  }

  NoTitleStyle.dark(BuildContext context, {bool haveRadius: false}) : super(context) {
    this.showTitleBar =  false;
    this.backgroundColor = Colors.grey[800];
    this.textColor = Colors.white;
  }
}