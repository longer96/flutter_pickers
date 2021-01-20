import 'package:flutter/material.dart';
import 'package:flutter_pickers/style/picker_style.dart';

class NoTitleStyle extends PickerStyle {
  NoTitleStyle() {
    this.showTitleBar =  false;
  }

  NoTitleStyle.dark({bool haveRadius: false}) {
    this.showTitleBar =  false;
    this.backgroundColor = Colors.grey[800];
    this.textColor = Colors.white;
  }
}