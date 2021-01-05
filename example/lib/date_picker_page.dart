import 'package:example/demo/pic_help.dart';
import 'package:example/widget/my_app_bar.dart';
import 'package:example/widget/my_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pickers/pickers/init_data.dart';
import 'package:flutter_pickers/pickers/pickers.dart';

class DatePickerPage extends StatefulWidget {
  @override
  _DatePickerPageState createState() => _DatePickerPageState();
}

class _DatePickerPageState extends State<DatePickerPage> {
  String stateText = '';

  final divider = Divider(height: 1, indent: 20);
  final rightIcon = Icon(Icons.keyboard_arrow_right);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: '测试demo'),
      body: ListView(
        children: [
          MyText(stateText ?? '内容'),
          RaisedButton(onPressed: () => show(context, 'yyyyMMdd', '20201112'), child: MyText('text')),
          Container(
            height: 200,
            color: Colors.grey[200],
            child: CupertinoTimerPicker(
                initialTimerDuration: Duration(hours: 23, minutes: 3, seconds: 56),
                onTimerDurationChanged: (Duration duration) {}),
          ),
          Divider(),
          Container(
            height: 200,
            color: Colors.grey[200],
            child: CupertinoDatePicker(
              initialDateTime: DateTime(2020,3),
              onDateTimeChanged: (data) {
                print('longer >>> $data');
              },
            ),
          ),

          _item('测试选择器', PickerDataType.sex, 'selectSex'),

        ],
      ),
    );
  }

  void show(context, timeFormat, dateParam) {
    PickHelper.openDateTimePicker(
      context,
      maxValue: DateTime.now().add(Duration(days: 999)),
      minValue: DateTime.now(),
      onConfirm: (_, __) {},
    );
  }

  Widget _item(title, var data, var selectData, {String label}) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          child: ListTile(
            title: Text(title),
            onTap: () => _onClickItem(),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
              MyText(selectData.toString() ?? '暂无', color: Colors.grey, rightpadding: 18),
              rightIcon
            ]),
          ),
        ),
        divider,
      ],
    );
  }

  void _onClickItem() {
    Pickers.showDatePicker(
      context,
      showTitleBar: true,

      onConfirm: (p) {
        print('longer >>> 返回数据：$p');
        print('longer >>> 返回数据类型：${p.runtimeType}');
        setState(() {
        });
      },
    );
  }


}
