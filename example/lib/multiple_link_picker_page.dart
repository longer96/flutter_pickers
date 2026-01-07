import 'package:example/widget/my_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pickers/pickers.dart';

class MultipleLinkPickerPage extends StatefulWidget {
  const MultipleLinkPickerPage({super.key});

  @override
  State<MultipleLinkPickerPage> createState() => _MultipleLinkPickerPageState();
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
      columnNum: 5,
      suffix: ['', '', '', '', ''],
      onConfirm: (List p, List<int> position) {
        debugPrint('longer >>> 返回数据：${p.join('、')}');
        debugPrint('longer >>> 返回数据下标：${position.join('、')}');
        debugPrint('longer >>> 返回数据类型：${p.map((x) => x.runtimeType).toList()}');
      },
    );
  }
}
