import 'package:flutter/material.dart';
import 'package:flutter_pickers/style/picker_style.dart';

class DefaultPickerStyle extends PickerStyle {
  DefaultPickerStyle({bool haveRadius: false}) {
    if (haveRadius) {
      this.headDecoration = BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)));
    }
  }

  DefaultPickerStyle.dark({bool haveRadius: false}) {
    this.commitButton = Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(left: 12, right: 22),
      child: Text('确定', style: TextStyle(color: Colors.white, fontSize: 16.0)),
    );

    this.cancelButton = Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(left: 22, right: 12),
      child: Text('取消', style: TextStyle(color: Colors.white, fontSize: 16.0)),
    );

    this.headDecoration = BoxDecoration(
        color: Colors.grey[800],
        borderRadius:
            !haveRadius ? null : BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)));

    this.backgroundColor = Colors.grey[800];
    this.textColor = Colors.white;
  }
}

class DefaultPickerStyle1 extends PickerStyle {
  DefaultPickerStyle1({bool haveRadius: false, String title}) {
    if (haveRadius) {
      this.headDecoration = BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)));
    }

    this.cancelButton = SizedBox();
    this.title = Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Align(
          alignment: Alignment.centerLeft, child: Text('身高选择器', style: TextStyle(color: Colors.grey, fontSize: 14))),
    );
    this.commitButton = Container(
      // padding: const EdgeInsets.all(4),
      margin: const EdgeInsets.only(right: 12),
      child: Icon(Icons.close, color: Colors.grey, size: 28),
    );
  }

  DefaultPickerStyle1.dark({bool haveRadius: false}) {
    this.commitButton = Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(left: 12, right: 22),
      child: Text('确定', style: TextStyle(color: Colors.white, fontSize: 16.0)),
    );

    this.cancelButton = Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(left: 22, right: 12),
      child: Text('取消', style: TextStyle(color: Colors.white, fontSize: 16.0)),
    );

    this.headDecoration = BoxDecoration(
        color: Colors.grey[800],
        borderRadius:
            !haveRadius ? null : BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)));

    this.backgroundColor = Colors.grey[800];
    this.textColor = Colors.white;
  }
}
