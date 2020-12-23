import 'package:example/widget/my_app_bar.dart';
import 'package:example/widget/my_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pickers/pickers/picker.dart';
import 'package:flutter_pickers/pickers/init_data.dart';

class MultiplePickerPage extends StatefulWidget {
  @override
  _MultiplePickerPageState createState() => _MultiplePickerPageState();
}

class _MultiplePickerPageState extends State<MultiplePickerPage> {
  String hourse = '13';
  String minute = '58';

  Map<String, List> timeData;

  final divider = Divider(height: 1, indent: 20);
  final rightIcon = Icon(Icons.keyboard_arrow_right);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: '多列选择器'),
      body: ListView(children: [
        _item('时间', PickerDataType.sex, timeData),
      ]),
    );
  }

  Widget _item(title, var data, selectData, {String label}) {
    timeData = {
      hourse: List.generate(24, (index) => (index + 1).toString()),
      minute: List.generate(60, (index) => index.toString())
    };

    return Column(
      children: [
        Container(
          color: Colors.white,
          child: ListTile(
            title: Text(title),
            onTap: () => _onClickItem(timeData, selectData, label: label),
            trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[MyText('$hourse时 $minute分', color: Colors.grey, rightpadding: 18), rightIcon]),
          ),
        ),
        divider,
      ],
    );
  }

  void _onClickItem(Map data, selectData, {String label}) {
    Picker.showMultiplePicker(
      context,
      showTitleBar: true,
      data: data,
      label: label,
      selectData: selectData,
      onConfirm: (p) {
        setState(() {
          hourse = p[0];
          minute = p[1];
        });
      },
    );
  }

}
