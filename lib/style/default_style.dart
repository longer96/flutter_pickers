import 'package:flutter/material.dart';
import 'package:flutter_pickers/style/picker_style.dart';

// 日间圆角
final headDecorationLight = BoxDecoration(
    color: Colors.white,
    borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)));

/// 无标题样式
class NoTitleStyle extends PickerStyle {
  NoTitleStyle() {
    this.showTitleBar = false;
  }

  /// 夜间
  NoTitleStyle.dark() {
    this.showTitleBar = false;
    this.backgroundColor = Colors.grey[800]!;
    this.textColor = Colors.white;
  }
}

/// 默认样式
class DefaultPickerStyle extends PickerStyle {
  DefaultPickerStyle({bool haveRadius: false, String? title}) {
    if (haveRadius) {
      this.headDecoration = BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)));
    }
    if (title != null && title != '') {
      this.title = Center(child: Text(title, style: TextStyle(color: Colors.grey, fontSize: 14)));
    }
  }

  /// 夜间
  DefaultPickerStyle.dark({bool haveRadius: false, String? title}) {
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

    if (title != null && title != '') {
      this.title = Center(child: Text(title, style: TextStyle(color: Colors.white, fontSize: 14)));
    }

    this.backgroundColor = Colors.grey[800]!;
    this.textColor = Colors.white;
  }
}

/// 关闭按钮样式
class ClosePickerStyle extends PickerStyle {
  /// 日间
  ClosePickerStyle({bool haveRadius: false, String? title}) {
    if (haveRadius) {
      this.headDecoration = BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)));
    }

    this.cancelButton = SizedBox();
    if (title != null && title != '') {
      this.title = Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Align(
            alignment: Alignment.centerLeft, child: Text(title, style: TextStyle(color: Colors.grey, fontSize: 14))),
      );
    }
    this.commitButton = Container(
      // padding: const EdgeInsets.all(4),
      margin: const EdgeInsets.only(right: 12),
      child: Icon(Icons.close, color: Colors.grey, size: 28),
    );
  }

  /// 夜间
  ClosePickerStyle.dark({bool haveRadius: false, String? title}) {
    this.headDecoration = BoxDecoration(
        color: Colors.grey[800],
        borderRadius:
            !haveRadius ? null : BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)));

    this.cancelButton = SizedBox();
    this.commitButton = Container(
      margin: const EdgeInsets.only(right: 12),
      child: Icon(Icons.close, color: Colors.white, size: 28),
    );
    if (title != null && title != '') {
      this.title = Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Align(
            alignment: Alignment.centerLeft, child: Text(title, style: TextStyle(color: Colors.white, fontSize: 14))),
      );
    }

    this.backgroundColor = Colors.grey[800]!;
    this.textColor = Colors.white;
  }
}

/// 圆角按钮样式
class RaisedPickerStyle extends PickerStyle {
  RaisedPickerStyle({bool haveRadius: false, String? title, Color color: Colors.blue}) {
    if (haveRadius) {
      this.headDecoration = BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)));
    }
    this.commitButton = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      margin: const EdgeInsets.only(right: 22),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
      child: Text('确定', style: TextStyle(color: Colors.white, fontSize: 15.0)),
    );

    this.cancelButton = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      margin: const EdgeInsets.only(left: 22),
      decoration: BoxDecoration(border: Border.all(color: color, width: 1), borderRadius: BorderRadius.circular(4)),
      child: Text('取消', style: TextStyle(color: color, fontSize: 15.0)),
    );

    if (title != null && title != '') {
      this.title = Center(child: Text(title, style: TextStyle(color: Colors.grey, fontSize: 14)));
    }
  }

  /// 夜间
  RaisedPickerStyle.dark({bool haveRadius: false, String? title, Color? color}) {
    this.headDecoration = BoxDecoration(
        color: Colors.grey[800],
        borderRadius:
            !haveRadius ? null : BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)));

    this.commitButton = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      margin: const EdgeInsets.only(right: 22),
      decoration: BoxDecoration(color: color ?? Colors.blue, borderRadius: BorderRadius.circular(4)),
      child: Text('确定', style: TextStyle(color: Colors.white, fontSize: 15.0)),
    );

    this.cancelButton = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      margin: const EdgeInsets.only(left: 22),
      decoration:
          BoxDecoration(border: Border.all(color: Colors.white, width: 1), borderRadius: BorderRadius.circular(4)),
      child: Text('取消', style: TextStyle(color: Colors.white, fontSize: 15.0)),
    );

    if (title != null && title != '') {
      this.title = Center(child: Text(title, style: TextStyle(color: Colors.white, fontSize: 14)));
    }

    this.backgroundColor = Colors.grey[800]!;
    this.textColor = Colors.white;
  }
}
