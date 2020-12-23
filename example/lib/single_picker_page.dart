import 'package:example/widget/my_app_bar.dart';
import 'package:example/widget/my_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pickers/pickers/picker.dart';
import 'package:flutter_pickers/pickers/init_data.dart';

class SinglePickerPage extends StatefulWidget {
  @override
  _SinglePickerPageState createState() => _SinglePickerPageState();
}

class _SinglePickerPageState extends State<SinglePickerPage> {
  String selectSex = '女';
  String selectEdu;
  String selectSubject;
  String selectConstellation;
  String selectZodiac = '龙';
  String selectHeight = '165';
  String selectEthnicity = '汉族';

  final divider = Divider(height: 1, indent: 20);
  final rightIcon = Icon(Icons.keyboard_arrow_right);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: '单列选择器'),
      body: ListView(children: [
        _item('性别', PickerDataType.sex, selectSex),
        _item('学历', PickerDataType.education, selectEdu),
        _item('学科', PickerDataType.subject, selectSubject),
        _item('星座', PickerDataType.constellation, selectConstellation),
        _item('生肖', PickerDataType.zodiac, selectZodiac),
        _item('名族', PickerDataType.ethnicity, selectEthnicity),
        _item('自定义数据 (单列)', ['PHP', 'JAVA', 'C++', 'Dart', 'Python', 'Go'], "Dart"),
        _item('身高', List.generate(200, (index) => (50 + index).toString()), "168", label: 'cm'),
        _item('温度', List.generate(110, (index) => (33.0 + index * .1).toString()), "37.5", label: '℃'),
        _item('Laber', [123, '空', '空空', '空空空', '空空空空', '空空空空空', '空空空空空空', '空空空空空空空'], "", label: 'kg'),
        _item2('自定义样式'),
      ]),
    );
  }

  Widget _item(title, var data, selectData, {String label}) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          child: ListTile(
            title: Text(title),
            onTap: () => _onClickItem(data, selectData, label: label),
            trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[MyText(selectData ?? '暂无', color: Colors.grey, rightpadding: 18), rightIcon]),
          ),
        ),
        divider,
      ],
    );
  }

  void _onClickItem(var data, selectData, {String label}) {
    Picker.showSinglePicker(
      context,
      showTitleBar: true,
      data: data,
      label: label,
      selectData: selectData,
      onConfirm: (p) {
        setState(() {
          if (data == PickerDataType.sex) {
            selectSex = p;
          } else if (data == PickerDataType.education) {
            selectEdu = p;
          } else if (data == PickerDataType.subject) {
            selectSubject = p;
          } else if (data == PickerDataType.constellation) {
            selectConstellation = p;
          } else if (data == PickerDataType.zodiac) {
            selectZodiac = p;
          }else if (data == PickerDataType.ethnicity) {
            selectEthnicity = p;
          }
        });
      },
    );
  }

  Widget _item2(title) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          child: ListTile(
            title: Text(title),
            onTap: () => _onClickItem2(),
            trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[MyText(selectHeight ?? '暂无', color: Colors.grey, rightpadding: 18), rightIcon]),
          ),
        ),
        divider,
      ],
    );
  }

  void _onClickItem2() {

    double menuHeight = 36.0;
    Widget _headMenuView = Container(
        color: Colors.grey[700],
        height: menuHeight,
        child: Center(child: MyText('净身高', color: Colors.white)));

    Widget _cancelButton = Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
      margin: const EdgeInsets.only(left: 12),
      decoration:
      BoxDecoration(border: Border.all(color: Colors.white, width: 1), borderRadius: BorderRadius.circular(4)),
      child: MyText('取消', color: Colors.white, size: 14),
    );

    Widget _commitButton = Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(4)),
      child: MyText('确认', color: Colors.white, size: 14),
    );

    // 头部样式
    Decoration headDecoration = BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)));

    Widget title = MyText('身高选择器', color: Colors.white, size: 14);

    Widget laber = MyText('cm', color: Colors.white, size: 22, fontWeight: FontWeight.w500,letfpadding: 90);


    Picker.showSinglePicker(
      context,
      showTitleBar: true,
      data: List.generate(200, (index) => (50 + index).toString()),
      selectData: selectHeight,

      menu: _headMenuView,
      menuHeight: menuHeight,
      title: title,
      cancelWidget: _cancelButton,
      commitWidget: _commitButton,
      headDecoration: headDecoration,
      textColor: Colors.white,
      backgroundColor: Colors.grey[800],
      labelWidget: laber,

      onConfirm: (p) {
        setState(() {
          selectHeight = p;
        });
      },
    );
  }
}
