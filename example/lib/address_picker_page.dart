import 'package:example/widget/my_app_bar.dart';
import 'package:example/widget/my_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_pickers/style/picker_style.dart';

class AddressPickerPage extends StatefulWidget {
  @override
  _AddressPickerPageState createState() => _AddressPickerPageState();
}

class _AddressPickerPageState extends State<AddressPickerPage> {
  // 所在区域  省 市 区
  String initProvince = '四川省', initCity = '成都市', initTown = '双流区';

  // 选择器2
  List locations1 = ['', ''];

  // 选择器3
  List locations2 = ['四川省', '成都市', '双流区'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: '地址选择器'),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('三级地址选择'),
            _checkLocation(),
            SizedBox(height: 20),
            Text('二级地址选择'),
            _checkLocation2(),
            SizedBox(height: 20),
            Text('更多参数说明'),
            SizedBox(height: 6),
            _checkLocation3(),
          ],
        ),
      ),
    );
  }

  Widget _checkLocation() {
    Widget textView = Text(
        spliceCityName(pname: initProvince, cname: initCity, tname: initTown));

    return InkWell(
      onTap: () {
        Pickers.showAddressPicker(
          context,
          initProvince: initProvince,
          initCity: initCity,
          initTown: initTown,
          onConfirm: (p, c, t) {
            setState(() {
              initProvince = p;
              initCity = c;
              initTown = t ?? '';
            });
          },
        );
      },
      child: _outsideView(textView, initProvince, initCity, initTown),
    );
  }

  Widget _checkLocation2() {
    Widget textView =
        Text(spliceCityName(pname: locations1[0], cname: locations1[1]));

    return InkWell(
      onTap: () {
        Pickers.showAddressPicker(
          context,
          initProvince: locations1[0],
          initCity: locations1[1],
          // initTown: null,
          onConfirm: (p, c, t) {
            setState(() {
              locations1[0] = p;
              locations1[1] = c;
            });
          },
        );
      },
      child: _outsideView(textView, locations1[0], locations1[1], null),
    );
  }

  Widget _checkLocation3() {
    double menuHeight = 36.0;
    Widget _headMenuView = Container(
        color: Colors.grey[700],
        height: menuHeight,
        child: Row(children: [
          Expanded(child: Center(child: MyText('省', color: Colors.white))),
          Expanded(child: Center(child: MyText('市', color: Colors.white))),
          Expanded(child: Center(child: MyText('区', color: Colors.white))),
        ]));

    Widget _cancelButton = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      margin: const EdgeInsets.only(left: 22),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 1),
          borderRadius: BorderRadius.circular(4)),
      child: MyText('取消', color: Colors.white, size: 14),
    );

    Widget _commitButton = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      margin: const EdgeInsets.only(right: 22),
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(4)),
      child: MyText('确认', color: Colors.white, size: 14),
    );

    // 头部样式
    Decoration headDecoration = BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8), topRight: Radius.circular(8)));

    Widget title =
        Center(child: MyText('请选择地址', color: Colors.white, size: 14));

    /// item 覆盖样式
    Widget itemOverlay = Container(
      decoration: BoxDecoration(
        border: Border.symmetric(
            horizontal: BorderSide(color: Colors.grey, width: 0.7)),
      ),
    );

    var pickerStyle = PickerStyle(
      menu: _headMenuView,
      menuHeight: menuHeight,
      cancelButton: _cancelButton,
      commitButton: _commitButton,
      headDecoration: headDecoration,
      title: title,
      textColor: Colors.white,
      backgroundColor: Colors.grey[800],
      itemOverlay: itemOverlay,
    );

    return InkWell(
      onTap: () {
        Pickers.showAddressPicker(
          context,
          initProvince: locations2[0],
          initCity: locations2[1],
          initTown: locations2[2],
          pickerStyle: pickerStyle,
          addAllItem: false,
          onConfirm: (p, c, t) {
            setState(() {
              locations2[0] = p;
              locations2[1] = c;
              locations2[2] = t;
            });
          },
        );
      },
      child: Text(
          spliceCityName(
              pname: locations2[0], cname: locations2[1], tname: locations2[2]),
          style: TextStyle(fontSize: 16)),
    );
  }

  Widget _outsideView(Widget textView, initProvince, initCity, initTown) {
    return Container(
      constraints: const BoxConstraints(minHeight: 42),
      padding: const EdgeInsets.fromLTRB(10, 0, 12, 0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          textView,
          SizedBox(width: 8),
          (initProvince != '')
              ? InkWell(
                  child: Icon(Icons.close, size: 20, color: Colors.grey[500]),
                  onTap: () {
                    setState(() {
                      initProvince = '';
                      initCity = '';
                      initTown = '';
                    });
                  })
              : SizedBox(),
          SizedBox(width: 8),
          Icon(Icons.keyboard_arrow_down, size: 28, color: Colors.grey[500]),
        ],
      ),
    );
  }

  // 拼接城市
  String spliceCityName({String? pname, String? cname, String? tname}) {
    if (strEmpty(pname)) return '不限';
    StringBuffer sb = StringBuffer();
    sb.write(pname);
    if (strEmpty(cname)) return sb.toString();
    sb.write(' - ');
    sb.write(cname);
    if (strEmpty(tname)) return sb.toString();
    sb.write(' - ');
    sb.write(tname);
    return sb.toString();
  }

  /// 字符串为空
  bool strEmpty(String? value) {
    if (value == null) return true;

    return value.trim().isEmpty;
  }
}
