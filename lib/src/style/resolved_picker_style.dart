import 'package:flutter/material.dart';
import 'package:flutter_pickers/style/picker_style.dart';

/// Resolves a mutable public [PickerStyle] into the immutable snapshot used by
/// one open picker.
PickerStyle resolvePickerStyle(PickerStyle source, BuildContext context) {
  // Keep the historical public side effect while ensuring every invocation
  // resolves inherited values from its own context.
  source.context = context;

  return PickerStyle(
    context: context,
    showTitleBar: source.showTitleBar,
    safeArea: source.safeArea,
    menu: source.menu,
    pickerHeight: source.pickerHeight,
    pickerTitleHeight: source.pickerTitleHeight,
    pickerItemHeight: source.pickerItemHeight,
    menuHeight: source.menuHeight,
    cancelButton: source.cancelButton,
    commitButton: source.commitButton,
    title: source.title,
    headDecoration: source.headDecoration,
    backgroundColor: source.backgroundColor,
    textColor: source.textColor,
    textSize: source.textSize,
    itemOverlay: source.itemOverlay,
  );
}
