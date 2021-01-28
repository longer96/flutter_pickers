import 'package:example/widget/my_app_bar.dart';
import 'package:example/widget/my_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_pickers/style/picker_style.dart';
import 'package:flutter_pickers/time_picker/model/date_mode.dart';
import 'package:flutter_pickers/time_picker/model/pduration.dart';
import 'package:flutter_pickers/time_picker/model/suffix.dart';

class DatePickerPage extends StatefulWidget {
  @override
  _DatePickerPageState createState() => _DatePickerPageState();
}

class _DatePickerPageState extends State<DatePickerPage> {
  String stateText = '';
  var selectData = {DateMode.YMDHMS: ''};

  final divider = Divider(height: 1, indent: 20);
  final rightIcon = Icon(Icons.keyboard_arrow_right);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: '时间选择器'),
      body: ListView(
        children: [
          _item('年月日时分秒', DateMode.YMDHMS),
          _item('年月日', DateMode.YMD),
          _item('时分秒', DateMode.HMS),
          _item('月日', DateMode.MD),
          _item('计时器', DateMode.HMS),
        ],
      ),
    );
  }

  Widget _item(title, model) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          child: ListTile(
            title: Text(title),
            onTap: () {
              if ('计时器' == title) {
                _onClickItem2();
              } else {
                _onClickItem(model);
              }
            },
            trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[MyText(selectData[model] ?? '暂无', color: Colors.grey, rightpadding: 18), rightIcon]),
          ),
        ),
        divider,
      ],
    );
  }

  void _onClickItem(model) {
    Pickers.showDatePicker(
      context,
      mode: model,
      suffix: Suffix.normal(),

      // selectDate: PDuration(month: 2),
      // minDate: PDuration(year: 2020, month: 1, day: 4),
      // maxDate: PDuration(year: 2021, month: 5, day: 22),

      selectDate: PDuration(hour: 18, minute: 36, second: 36),
      minDate: PDuration(hour: 12, minute: 38, second: 3),
      maxDate: PDuration(hour: 12, minute: 40, second: 36),
      onConfirm: (p) {
        print('longer >>> 返回数据：$p');
        setState(() {
          switch (model) {
            case DateMode.YMDHMS:
              selectData[model] = '${p.year}-${p.month}-${p.day} ${p.hour}:${p.minute}:${p.second}';
              break;
            case DateMode.YMD:
              selectData[model] = '${p.year}-${p.month}-${p.day}';
              break;
            case DateMode.HMS:
              selectData[model] = '${p.hour}:${p.minute}:${p.second}';
              break;
          }
        });
      },
      // onChanged: (p) => print(p),
    );
  }

  void _onClickItem2() {
    Widget _cancelButton = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      margin: const EdgeInsets.only(left: 22),
      decoration:
          BoxDecoration(border: Border.all(color: Colors.white, width: 1), borderRadius: BorderRadius.circular(4)),
      child: MyText('取消', color: Colors.white, size: 14),
    );

    Widget _commitButton = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      margin: const EdgeInsets.only(right: 22),
      decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(4)),
      child: MyText('确认', color: Colors.white, size: 14),
    );

    // 头部样式
    Decoration headDecoration = BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)));

    Widget title = Center(child: MyText('倒计时', color: Colors.white, size: 14));

    var pickerStyle = PickerStyle(
        cancelButton: _cancelButton,
        commitButton: _commitButton,
        headDecoration: headDecoration,
        title: title,
        textColor: Colors.white,
        backgroundColor: Colors.grey[800]);

    Pickers.showDatePicker(
      context,
      mode: DateMode.HMS,
      suffix: Suffix(hours: ' 小时', minutes: ' 分钟', seconds: ' 秒'),
      pickerStyle: pickerStyle,
      onConfirm: (p) {
        print('longer >>> 返回数据：$p');
      },
      // onChanged: (p) => print(p),
    );
  }
}
