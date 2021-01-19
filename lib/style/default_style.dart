import 'package:flutter/material.dart';
import 'package:flutter_pickers/style/picker_style.dart';

class DefaultPickerStyle extends PickerStyle {
  DefaultPickerStyle(BuildContext context, {bool haveRadius: false}) : super(context) {
    if (haveRadius) {
      this.headDecoration = BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)));
    }
  }

  DefaultPickerStyle.dark(BuildContext context, {bool haveRadius: false}) : super(context) {
    this.commitButton = getCommitButton();
    this.cancelButton = getCancelButton();
    // 黑色 圆角
    this.headDecoration = BoxDecoration(
        color: Colors.grey[800],
        borderRadius:
            !haveRadius ? null : BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)));

    this.backgroundColor = Colors.grey[800];
    this.textColor = Colors.white;
  }
}




Widget getCommitButton() {
  return Container(
    alignment: Alignment.center,
    padding: const EdgeInsets.only(left: 12, right: 22),
    child: Text('确定', style: TextStyle(color: Colors.white, fontSize: 16.0)),
  );
}

Widget getCancelButton() {
  return Container(
    alignment: Alignment.center,
    padding: const EdgeInsets.only(left: 22, right: 12),
    child: Text('取消', style: TextStyle(color: Colors.white, fontSize: 16.0)),
  );
}
