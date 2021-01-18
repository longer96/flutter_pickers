import 'package:flutter/material.dart';
import 'package:flutter_pickers/style/picker_style.dart';

class DefaultStyle extends BasePickerStyle {
  bool dark = false;

  DefaultStyle(BuildContext context) : super(context);

  DefaultStyle.dark(BuildContext context) : super(context){
    this.dark = true;
    menuHeight = 200;
  }


}
