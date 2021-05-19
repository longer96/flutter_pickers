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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: '多列选择器（联动）'),
      body: Center(
        child: Column(children: [
          ElevatedButton(onPressed: _showPicker, child: Text('Demo')),
        ]),
      ),
    );
  }

  void _showPicker() {
    var multiData = {
      'a': {
        'aa': [1, 'ww'],
        'aaa': 10086
      },
      'b': ['bbb', 'bbbbb'],
      'c': {
        'cc': {
          'ccc333': [111, 1111],
          'cccc33': {
            'ccccc4': '帮忙star',
            'ccc4-2': [4442, 44442, 442]
          },
        },
        'cc2': ['ccc', 123],
        'cc3': 'star 鼓励'
      }
    };

    Pickers.showMultiLinkPicker(
      context,
      data: multiData,
      // 注意数据类型要对应 比如 44442 写成字符串类型'44442'，则找不到
      // selectData: ['c', 'cc', 'cccc33', 'ccc4-2', 44442],
      selectData: ['c', 'cc3'],
      columeNum: 5,
      suffix: ['', '', '', '', ''],
      onConfirm: (List p, List<int> position) {
        print('longer >>> 返回数据：${p.join('、')}');
        print('longer >>> 返回数据下标：${position.join('、')}');
        print('longer >>> 返回数据类型：${p.map((x) => x.runtimeType).toList()}');
      },
    );
  }
}
