import 'package:flutter/material.dart';
import 'package:flutter_pickers/src/style/resolved_picker_style.dart';
import 'package:flutter_pickers/style/picker_style.dart';

/// Shared popup lifecycle and page assembly for every picker route.
abstract class PickerPopupRoute<T> extends PopupRoute<T> {
  PickerPopupRoute({
    PickerStyle? pickerStyle,
    this.theme,
    this.onCancel,
    this.barrierLabel,
    super.settings,
  }) : pickerStyle = pickerStyle ?? PickerStyle();

  final PickerStyle pickerStyle;
  final ThemeData? theme;
  final Function(bool isCancel)? onCancel;

  @override
  final String? barrierLabel;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  @override
  bool get barrierDismissible => true;

  @override
  Color get barrierColor => Colors.black54;

  @override
  bool didPop(T? result) {
    if (result == null) {
      onCancel?.call(false);
    } else if (!(result as bool)) {
      onCancel?.call(true);
    }
    return super.didPop(result);
  }

  @override
  AnimationController createAnimationController() {
    return BottomSheet.createAnimationController(navigator!.overlay!);
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    final resolvedStyle = resolvePickerStyle(pickerStyle, context);
    // viewPadding remains stable while the keyboard is visible, preserving
    // Android gesture navigation and the iOS home indicator on full screens.
    final safeAreaBottom = resolvedStyle.safeArea
        ? MediaQuery.of(context).viewPadding.bottom
        : 0.0;

    Widget sheet = MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: buildPickerContent(context, resolvedStyle, safeAreaBottom),
    );
    if (theme != null) {
      sheet = Theme(data: theme!, child: sheet);
    }
    return sheet;
  }

  Widget buildPickerContent(
    BuildContext context,
    PickerStyle resolvedStyle,
    double safeAreaBottom,
  );
}
