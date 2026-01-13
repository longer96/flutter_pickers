import 'package:flutter/material.dart';
import 'package:flutter_pickers/address_picker/route/address_picker_route.dart';
import 'package:flutter_pickers/more_pickers/init_data.dart';
import 'package:flutter_pickers/more_pickers/route/multiple_link_picker_route.dart';
import 'package:flutter_pickers/more_pickers/route/multiple_picker_route.dart';
import 'package:flutter_pickers/more_pickers/route/single_picker_route.dart';
import 'package:flutter_pickers/style/default_style.dart';
import 'package:flutter_pickers/style/picker_style.dart';
import 'package:flutter_pickers/time_picker/model/date_mode.dart';
import 'package:flutter_pickers/time_picker/model/pduration.dart';
import 'package:flutter_pickers/time_picker/model/suffix.dart';
import 'package:flutter_pickers/time_picker/route/date_picker_route.dart';
import 'time_picker/model/date_item_model.dart';

/// Flutter 选择器工具类
///
/// 提供多种选择器：
/// - [showSinglePicker] 单列选择器
/// - [showMultiPicker] 多列选择器（无联动）
/// - [showMultiLinkPicker] 多列选择器（有联动）
/// - [showAddressPicker] 地址选择器
/// - [showDatePicker] 时间选择器
class Pickers {
  // 私有构造函数，防止实例化
  Pickers._();
  /// 单列通用选择器
  ///
  /// [context] 上下文
  /// [data] 数据源，可以是 List 或 PickerDataType
  /// [selectData] 初始选中的数据
  /// [suffix] 后缀文本
  /// [pickerStyle] 选择器样式
  /// [onChanged] 选择器发生变动时的回调
  /// [onConfirm] 选择器确认时的回调
  /// [onCancel] 选择器取消时的回调
  /// [overlapTabBar] 是否覆盖 TabBar
  static void showSinglePicker(
    BuildContext context, {
    required dynamic data,
    dynamic selectData,
    String? suffix,
    PickerStyle? pickerStyle,
    SingleCallback? onChanged,
    SingleCallback? onConfirm,
    Function(bool isCancel)? onCancel,
    bool overlapTabBar = false,
  }) {
    assert(
      (data is List) || (data is PickerDataType),
      'params : data must List or PickerDataType',
    );

    final style = _initPickerStyle(pickerStyle, context);

    Navigator.of(context, rootNavigator: overlapTabBar).push(
      SinglePickerRoute(
        data: data,
        suffix: suffix,
        selectData: selectData,
        pickerStyle: style,
        onChanged: onChanged,
        onConfirm: onConfirm,
        onCancel: onCancel,
        theme: Theme.of(context),
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
      ),
    );
  }

  /// 多列选择器（无联动）
  ///
  /// [context] 上下文
  /// [data] 数据源，二维列表
  /// [selectData] 初始选中的数据列表
  /// [suffix] 每列的后缀文本列表
  /// [pickerStyle] 选择器样式
  /// [onChanged] 选择器发生变动时的回调
  /// [onConfirm] 选择器确认时的回调
  /// [onCancel] 选择器取消时的回调
  /// [overlapTabBar] 是否覆盖 TabBar
  static void showMultiPicker(
    BuildContext context, {
    required List<List> data,
    List? selectData,
    List? suffix,
    PickerStyle? pickerStyle,
    MultipleCallback? onChanged,
    MultipleCallback? onConfirm,
    Function(bool isCancel)? onCancel,
    bool overlapTabBar = false,
  }) {
    final style = _initPickerStyle(pickerStyle, context);

    Navigator.of(context, rootNavigator: overlapTabBar).push(
      MultiplePickerRoute(
        data: data,
        selectData: selectData ?? [],
        suffix: suffix,
        pickerStyle: style,
        onChanged: onChanged,
        onConfirm: onConfirm,
        onCancel: onCancel,
        theme: Theme.of(context),
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
      ),
    );
  }

  /// 多列选择器（有联动）
  ///
  /// [context] 上下文
  /// [data] 数据源，必须是 Map 类型
  /// [columnNum] 最大的列数
  /// [selectData] 初始选中的数据列表
  /// [suffix] 每列的后缀文本列表
  /// [pickerStyle] 选择器样式
  /// [onChanged] 选择器发生变动时的回调
  /// [onConfirm] 选择器确认时的回调
  /// [onCancel] 选择器取消时的回调
  /// [overlapTabBar] 是否覆盖 TabBar
  static void showMultiLinkPicker(
    BuildContext context, {
    required dynamic data,
    required int columnNum,
    List? selectData,
    List? suffix,
    PickerStyle? pickerStyle,
    MultipleLinkCallback? onChanged,
    MultipleLinkCallback? onConfirm,
    Function(bool isCancel)? onCancel,
    bool overlapTabBar = false,
  }) {
    assert(data is Map, 'params : data must Map');

    final style = _initPickerStyle(pickerStyle, context);

    Navigator.of(context, rootNavigator: overlapTabBar).push(
      MultipleLinkPickerRoute(
        data: data,
        selectData: selectData ?? [],
        columnNum: columnNum,
        suffix: suffix,
        pickerStyle: style,
        onChanged: onChanged,
        onConfirm: onConfirm,
        onCancel: onCancel,
        theme: Theme.of(context),
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
      ),
    );
  }

  /// 地区选择器
  ///
  /// [context] 上下文
  /// [pickerStyle] 选择器样式
  /// [initProvince] 初始化省份
  /// [initCity] 初始化城市
  /// [initTown] 初始化区县（为 null 时不显示区县）
  /// [addAllItem] 市、区是否添加 '全部' 选项，默认：true
  /// [onChanged] 选择器发生变动时的回调
  /// [onConfirm] 选择器确认时的回调
  /// [onCancel] 选择器取消时的回调
  /// [overlapTabBar] 是否覆盖 TabBar
  static void showAddressPicker(
    BuildContext context, {
    PickerStyle? pickerStyle,
    String initProvince = '',
    String initCity = '',
    String? initTown,
    bool addAllItem = true,
    AddressCallback? onChanged,
    AddressCallback? onConfirm,
    Function(bool isCancel)? onCancel,
    bool overlapTabBar = false,
  }) {
    final style = _initPickerStyle(pickerStyle, context);

    Navigator.of(context, rootNavigator: overlapTabBar).push(
      AddressPickerRoute(
        pickerStyle: style,
        initProvince: initProvince,
        initCity: initCity,
        initTown: initTown,
        onChanged: onChanged,
        onConfirm: onConfirm,
        onCancel: onCancel,
        addAllItem: addAllItem,
        theme: Theme.of(context),
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
      ),
    );
  }

  /// 时间选择器
  ///
  /// [context] 上下文
  /// [mode] 时间选择器显示模式，16 种时间样式，默认：DateMode.YMD
  /// [selectDate] 初始化选中时间，默认当前时间
  ///   - PDuration.now()
  ///   - PDuration.parse(DateTime.parse('20210101'))
  ///   - PDuration(year: 2020, month: 2)
  /// [maxDate] 最大时间，默认 2100 年
  /// [minDate] 最小时间，默认 1900 年
  /// [suffix] 每列时间对应的单位，默认中文常规
  /// [pickerStyle] 选择器样式
  /// [onChanged] 选择器发生变动时的回调
  /// [onConfirm] 选择器确认时的回调
  /// [onCancel] 选择器取消时的回调
  /// [overlapTabBar] 是否覆盖 TabBar
  ///
  /// **注意**：
  /// - 当只有单列数据时，min/max 限制不产生关联，只针对单列 item 限制
  /// - 如果用到了日期，selectDate 需要传入年份
  static void showDatePicker(
    BuildContext context, {
    DateMode mode = DateMode.YMD,
    PDuration? selectDate,
    PDuration? maxDate,
    PDuration? minDate,
    Suffix? suffix,
    PickerStyle? pickerStyle,
    DateCallback? onChanged,
    DateCallback? onConfirm,
    Function(bool isCancel)? onCancel,
    bool overlapTabBar = false,
  }) {
    final style = _initPickerStyle(pickerStyle, context);
    selectDate ??= PDuration.now();
    suffix ??= Suffix.normal();
    maxDate ??= PDuration(year: 2100);
    minDate ??= PDuration(year: 1900);

    // 解析是否有对应数据
    final dateItemModel = DateItemModel.parse(mode);

    if (dateItemModel.day || dateItemModel.year) {
      if (intEmpty(selectDate.year)) {
        debugPrint('picker Tip >>> initDate未设置years，默认设置为now().year');
        selectDate.year = DateTime.now().year;
      }

      // 如果有年 item，必须限制
      if (intEmpty(maxDate.year)) maxDate.year = 2100;
      if (intEmpty(minDate.year)) minDate.year = 1900;

      if (dateItemModel.month || dateItemModel.day) {
        assert(minDate.year! > 1582, 'min Date Year must > 1582');
      }
    }

    Navigator.of(context, rootNavigator: overlapTabBar).push(
      DatePickerRoute(
        mode: mode,
        initDate: selectDate,
        maxDate: maxDate,
        minDate: minDate,
        suffix: suffix,
        pickerStyle: style,
        onChanged: onChanged,
        onConfirm: onConfirm,
        onCancel: onCancel,
        theme: Theme.of(context),
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
      ) as Route<Object?>,
    );
  }

  /// 初始化选择器样式的辅助方法
  static PickerStyle _initPickerStyle(
    PickerStyle? pickerStyle,
    BuildContext context,
  ) {
    final style = pickerStyle ?? DefaultPickerStyle();
    style.context ??= context;
    return style;
  }
}
