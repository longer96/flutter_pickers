import 'package:example/widget/my_app_bar.dart';
import 'package:example/widget/my_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_pickers/more_pickers/init_data.dart';
import 'package:flutter_pickers/style/default_style.dart';
import 'package:flutter_pickers/style/picker_style.dart';

class StylePickerPage extends StatefulWidget {
  @override
  _StylePickerPageState createState() => _StylePickerPageState();
}

class _StylePickerPageState extends State<StylePickerPage> {
  final divider = Divider(height: 1, indent: 20);
  final rightIcon = Icon(Icons.keyboard_arrow_right);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: '内置样式'),
      body: ListView(children: [
        _item('默认样式1', DefaultPickerStyle1()),
        _item('默认样式(暗色)', DefaultPickerStyle1.dark()),
        _item('无标题', NoTitleStyle()),
        _item('无标题（暗色）', NoTitleStyle.dark()),
        _item('自定义样式', customizeStyle()),
      ]),
    );
  }

  Widget _item(title, pickerStyle) {
    return ListTile(title: Text(title), onTap: () => _onClickItem(pickerStyle), trailing: rightIcon);
  }

  void _onClickItem(pickerStyle) {
    Pickers.showSinglePicker(context,
        data: List.generate(200, (index) => (50 + index).toString()),
        pickerStyle: pickerStyle,
        onConfirm: (p) => print('返回数据：$p'),
        onChanged: (p) => print('数据发生改变：$p'));
  }

  PickerStyle customizeStyle(){
    double menuHeight = 36.0;
    Widget _headMenuView = Container(
        color: Colors.grey[700], height: menuHeight, child: Center(child: MyText('净身高', color: Colors.white)));

    Widget _cancelButton = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      margin: const EdgeInsets.only(left: 22),
      decoration:
      BoxDecoration(border: Border.all(color: Colors.white, width: 1), borderRadius: BorderRadius.circular(4)),
      child: MyText('取消', color: Colors.white, size: 14),
    );

    Widget _commitButton = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      margin: const EdgeInsets.only(right: 22),
      decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(4)),
      child: MyText('确认', color: Colors.white, size: 14),
    );

    // 头部样式
    Decoration headDecoration = BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)));

    Widget title = MyText('身高选择器', color: Colors.white, size: 14);

    Widget laber = MyText('cm', color: Colors.white, size: 22, fontWeight: FontWeight.w500, letfpadding: 90);

    return PickerStyle(
      menu: _headMenuView,
      cancelButton: _cancelButton,
      commitButton: _commitButton,
      headDecoration: headDecoration,
      title: title,
      labelWidget: laber,
      textColor: Colors.white,
      backgroundColor: Colors.grey[800],
    );
  }
}
