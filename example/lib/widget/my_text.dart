import 'package:flutter/material.dart';

class MyText extends StatelessWidget {
  const MyText(
    this.data, {
    Key? key,
    this.letfpadding = 0,
    this.toppadding = 0,
    this.rightpadding = 0,
    this.bottompadding = 0,
    this.size = 15,
    this.color = Colors.black87,
    this.fontWeight = FontWeight.w400,
    this.maxLines = 1000,
  }) :
//        assert(
//          data != null,
//          'text 不能为空哦~',
//        ),
        super(key: key);

  final String? data;
  final double letfpadding;
  final double toppadding;
  final double rightpadding;
  final double bottompadding;
  final double size;
  final Color color;
  final FontWeight fontWeight;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          letfpadding, toppadding, rightpadding, bottompadding),
      child: Text(
        data ?? "null",
        style: TextStyle(color: color, fontSize: size, fontWeight: fontWeight),
        overflow: TextOverflow.ellipsis,
        maxLines: maxLines,
      ),
    );
  }
}
