import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar(
      {this.title = '',
      this.centerTitle = true,
      this.rightDMActions,
      this.backgroundColor,
      this.mainColor,
      this.titleW,
      this.bottom,
      this.leadingImg = '',
      this.leadingW,
      this.brightness = Brightness.light,
      this.automaticallyImplyLeading = true,
      this.elevation = 4.0});

  final String title;
  final bool centerTitle; //标题是否居中，默认居中
  final List<Widget>? rightDMActions;
  final Color? backgroundColor;
  final Color? mainColor;
  final Widget? titleW;
  final Widget? leadingW;
  final PreferredSizeWidget? bottom;
  final String leadingImg;
  final double elevation;
  final Brightness brightness; //状态栏颜色 默认为白色文字
  final bool automaticallyImplyLeading; //配合leading 使用，如果左侧不需要图标 ，设置false

//  @override
//  Size get preferredSize => Size(100, 48);

  /// appbar 的高度  默认高度是：56  kToolbarHeight
  @override
  Size get preferredSize =>
      Size.fromHeight(48.0 + (bottom?.preferredSize.height ?? 0.0));

  Widget leading(BuildContext context) {
    final ModalRoute<dynamic> parentRoute = ModalRoute.of(context)!;
    final bool canPop = parentRoute.canPop;
    final bool useCloseButton =
        parentRoute is PageRoute<dynamic> && parentRoute.fullscreenDialog;

    return canPop
        ? useCloseButton
            ? CloseButton(color: mainColor)
            : BackButton(color: mainColor)
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: titleW == null
          ? Text(title,
              style: TextStyle(
                  color: mainColor,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w500))
          : titleW,
      backgroundColor: backgroundColor != null
          ? backgroundColor
          : Theme.of(context).primaryColor,
      // : Provider.of<ThemeModel>(context, listen: true).themeData.primaryColor,
      elevation: elevation,
      // brightness: brightness,
      leading:
          leadingW ?? (automaticallyImplyLeading ? leading(context) : null),
      automaticallyImplyLeading: automaticallyImplyLeading,
      centerTitle: centerTitle,
      actions: rightDMActions ?? [Center()],
      bottom: bottom != null ? bottom : null,
    );
  }
}
