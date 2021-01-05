
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';

const double _kPickerSheetHeight = 216.0;
const double _kPickerItemHeight = 32.0;

typedef PickerConfirmCityCallback = void Function(
    List<String> stringData, List<int> selecteds);

class PickHelper {

  ///日期选择器
  static void openDateTimePicker(
      BuildContext context, {
        String title,
        DateTime maxValue,
        DateTime minValue,
        DateTime value,
        DateTimePickerAdapter adapter,
        @required PickerConfirmCallback onConfirm,
      }) {
    openModalPicker(context,
        adapter: adapter ??
            DateTimePickerAdapter(
                type: PickerDateTimeType.kYMD,
                isNumberMonth: true,
                yearSuffix: "年",
                maxValue: maxValue ,
                minValue: minValue ,
                value: value ?? DateTime.now(),
                monthSuffix: "月",
                daySuffix: "日"),
        title: title,
        onConfirm: onConfirm);
  }


  static void openModalPicker(
      BuildContext context, {
        @required PickerAdapter adapter,
        String title,
        List<int> selecteds,
        @required PickerConfirmCallback onConfirm,
      }) {
    new Picker(
      adapter: adapter,
      title: new Text(title ?? ""),
      selecteds: selecteds,
      cancelText: '取消',
      confirmText: '确定',
      cancelTextStyle: TextStyle(color: Colors.black,fontSize: 16.0),
      confirmTextStyle: TextStyle(color: Colors.black,fontSize: 16.0),
      textAlign: TextAlign.right,
      itemExtent: _kPickerItemHeight,
      height: _kPickerSheetHeight,
      selectedTextStyle: TextStyle(color: Colors.black),
      onConfirm: onConfirm,
    ).showModal(context);
  }
}