import 'package:flutter/material.dart';
import 'package:flutter_pickers/style/picker_style.dart';

/// Shared animated shell for picker wheels, title actions, menu, and footer.
class PickerSheet extends StatelessWidget {
  const PickerSheet({
    super.key,
    required this.animation,
    required this.style,
    required this.safeAreaBottom,
    required this.body,
    required this.onConfirm,
    this.bodyPadding = EdgeInsets.zero,
    this.footer,
    this.footerHeight = 0.0,
  });

  final Animation<double> animation;
  final PickerStyle style;
  final double safeAreaBottom;
  final Widget body;
  final VoidCallback onConfirm;
  final EdgeInsetsGeometry bodyPadding;
  final Widget? footer;
  final double footerHeight;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return ClipRect(
          child: CustomSingleChildLayout(
            delegate: PickerSheetLayout(
              animation.value,
              style: style,
              safeAreaBottom: safeAreaBottom,
              footerHeight: footer == null ? 0.0 : footerHeight,
            ),
            child: Material(
              color: Colors.transparent,
              child: _buildContent(context),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context) {
    final bodySafeArea = footer == null ? safeAreaBottom : 0.0;
    final pickerBody = Container(
      height: style.pickerHeight + bodySafeArea,
      padding: bodyPadding.add(EdgeInsets.only(bottom: bodySafeArea)),
      color: style.backgroundColor,
      child: body,
    );

    final children = <Widget>[];
    if (style.showTitleBar) {
      children.add(_buildTitle(context));
    }
    if (style.menu != null) {
      children.add(style.menu!);
    }
    children.add(pickerBody);
    if (footer != null) {
      children.add(
        Container(
          height: footerHeight + safeAreaBottom,
          padding: EdgeInsets.only(bottom: safeAreaBottom),
          color: style.backgroundColor,
          child: SizedBox(height: footerHeight, child: footer),
        ),
      );
    }

    return children.length == 1 ? children.single : Column(children: children);
  }

  Widget _buildTitle(BuildContext context) {
    return Container(
      height: style.pickerTitleHeight,
      decoration: style.headDecoration,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () => Navigator.pop(context, false),
            child: style.cancelButton,
          ),
          Expanded(child: style.title),
          InkWell(
            onTap: () {
              onConfirm();
              Navigator.pop(context, true);
            },
            child: style.commitButton,
          ),
        ],
      ),
    );
  }
}

class PickerSheetLayout extends SingleChildLayoutDelegate {
  const PickerSheetLayout(
    this.progress, {
    required this.style,
    required this.safeAreaBottom,
    this.footerHeight = 0.0,
  });

  final double progress;
  final PickerStyle style;
  final double safeAreaBottom;
  final double footerHeight;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    var maxHeight = style.pickerHeight + safeAreaBottom + footerHeight;
    if (style.showTitleBar) {
      maxHeight += style.pickerTitleHeight;
    }
    if (style.menu != null) {
      maxHeight += style.menuHeight;
    }

    return BoxConstraints(
      minWidth: constraints.maxWidth,
      maxWidth: constraints.maxWidth,
      minHeight: 0.0,
      maxHeight: maxHeight,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return Offset(0.0, size.height - childSize.height * progress);
  }

  @override
  bool shouldRelayout(PickerSheetLayout oldDelegate) {
    return progress != oldDelegate.progress ||
        safeAreaBottom != oldDelegate.safeAreaBottom ||
        footerHeight != oldDelegate.footerHeight ||
        style != oldDelegate.style;
  }
}
