import 'package:example/demo/pic_help.dart';
import 'package:example/widget/my_app_bar.dart';
import 'package:example/widget/my_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pickers/more_pickers/init_data.dart';
import 'package:flutter_pickers/pickers.dart';
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
            onTap: () => _onClickItem(model),
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
          }
        });
      },
      onChanged: (p) {
//        print(p);
      },
    );
  }
}
