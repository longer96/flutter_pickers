import 'package:example/widget/my_app_bar.dart';
import 'package:example/widget/my_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_pickers/style/default_style.dart';
import 'package:flutter_pickers/style/picker_style.dart';

class MultipleLinkPickerPage extends StatefulWidget {
  @override
  _MultipleLinkPickerPageState createState() => _MultipleLinkPickerPageState();
}

class _MultipleLinkPickerPageState extends State<MultipleLinkPickerPage> {
  final divider = Divider(height: 1, indent: 20);
  final rightIcon = Icon(Icons.keyboard_arrow_right);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: '多列选择器（联动）'),
      body: ListView(children: [
        ElevatedButton(onPressed: _showDemo, child: Text('Demo')),
        SizedBox(height: 80)
      ]),
    );
  }

  void _showDemo() {
    var multiData = {
      'a': {
        'aa': [1],
        'aaa': [1]
      },
      'b': {
        'bb': [1],
        'bbb': [11, 22]
      },
      'c': {
        'cc': {
          'ccc333': [111, 1111],
          'cccc33': {
            'ccccc4': [11111]
          },
        },
      }
    };

    Pickers.showMultiLinkPicker(
      context,
      data: multiData,
      selectData: [],
      columeNum: 4,
      suffix: ['', '', '', ''],
      onConfirm: (p) {
        print('longer >>> 返回数据类型：${p.map((x) => x.runtimeType).toList()}');
      },
    );
  }
}
