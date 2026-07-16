import 'package:flutter/material.dart';
import 'package:flutter_pickers/address_picker/route/address_picker_route.dart';
import 'package:flutter_pickers/l10n/generated/app_localizations.dart';
import 'package:flutter_pickers/more_pickers/init_data.dart';
import 'package:flutter_pickers/more_pickers/route/multiple_link_picker_route.dart';
import 'package:flutter_pickers/more_pickers/route/multiple_picker_route.dart';
import 'package:flutter_pickers/more_pickers/route/single_picker_route.dart';
import 'package:flutter_pickers/src/style/resolved_picker_style.dart';
import 'package:flutter_pickers/style/default_style.dart';
import 'package:flutter_pickers/style/picker_style.dart';
import 'package:flutter_pickers/time_picker/model/date_mode.dart';
import 'package:flutter_pickers/time_picker/model/pduration.dart';
import 'package:flutter_pickers/time_picker/model/suffix.dart';
import 'package:flutter_pickers/time_picker/route/date_picker_route.dart';
import 'time_picker/model/date_item_model.dart';

export 'pickers_locale.dart';
export 'l10n/generated/app_localizations.dart';

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
  /// [editorBuilder] 选择器下方的自定义编辑区，可通过 updateSelection 与滚轮双向联动
  /// [editorHeight] 自定义编辑区高度
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
    MultiplePickerEditorBuilder? editorBuilder,
    double editorHeight = 56.0,
    bool overlapTabBar = false,
  }) {
    assert(editorHeight >= 0, 'editorHeight must not be negative');
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
        editorBuilder: editorBuilder,
        editorHeight: editorHeight,
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
    return resolvePickerStyle(style, context);
  }

  /// 获取国际化后的内置数据
  ///
  /// [type] 数据类型
  /// [context] BuildContext，用于获取本地化实例
  /// 返回 `List<String>` 类型的数据列表
  /// 如果 context 无法获取 AppLocalizations，返回中文数据
  static List<String> getData(PickerDataType type, BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return _getDefaultData(type);
    }
    return _getLocalizedData(type, l10n);
  }

  static List<String> _getDefaultData(PickerDataType type) {
    return pickerData[type] ?? [];
  }

  static List<String> _getLocalizedData(
      PickerDataType type, AppLocalizations l10n) {
    switch (type) {
      case PickerDataType.sex:
        return [l10n.sexAny, l10n.sexMale, l10n.sexFemale];
      case PickerDataType.education:
        return [
          l10n.educationBelowHighSchool,
          l10n.educationHighSchool,
          l10n.educationAssociate,
          l10n.educationBachelor,
          l10n.educationMaster,
          l10n.educationPhd,
          l10n.educationPostdoc,
          l10n.educationOther,
        ];
      case PickerDataType.subject:
        return [
          l10n.subjectChinese,
          l10n.subjectMath,
          l10n.subjectEnglish,
          l10n.subjectPhysics,
          l10n.subjectChemistry,
          l10n.subjectBiology,
          l10n.subjectPolitics,
          l10n.subjectGeography,
          l10n.subjectHistory,
        ];
      case PickerDataType.constellation:
        return [
          l10n.constellationAquarius,
          l10n.constellationPisces,
          l10n.constellationAries,
          l10n.constellationTaurus,
          l10n.constellationGemini,
          l10n.constellationCancer,
          l10n.constellationLeo,
          l10n.constellationVirgo,
          l10n.constellationLibra,
          l10n.constellationScorpio,
          l10n.constellationSagittarius,
          l10n.constellationCapricorn,
        ];
      case PickerDataType.zodiac:
        return [
          l10n.zodiacRat,
          l10n.zodiacOx,
          l10n.zodiacTiger,
          l10n.zodiacRabbit,
          l10n.zodiacDragon,
          l10n.zodiacSnake,
          l10n.zodiacHorse,
          l10n.zodiacGoat,
          l10n.zodiacMonkey,
          l10n.zodiacRooster,
          l10n.zodiacDog,
          l10n.zodiacPig,
        ];
      case PickerDataType.ethnicity:
        return [
          l10n.ethnicityHan,
          l10n.ethnicityMongol,
          l10n.ethnicityHui,
          l10n.ethnicityTibetan,
          l10n.ethnicityUygur,
          l10n.ethnicityMiao,
          l10n.ethnicityYi,
          l10n.ethnicityZhuang,
          l10n.ethnicityBouyei,
          l10n.ethnicityKorean,
          l10n.ethnicityManchu,
          l10n.ethnicityDong,
          l10n.ethnicityYao,
          l10n.ethnicityBai,
          l10n.ethnicityTujia,
          l10n.ethnicityHani,
          l10n.ethnicityKazak,
          l10n.ethnicityDai,
          l10n.ethnicityLi,
          l10n.ethnicityLisu,
          l10n.ethnicityVa,
          l10n.ethnicityShe,
          l10n.ethnicityGaoshan,
          l10n.ethnicityLahu,
          l10n.ethnicityShui,
          l10n.ethnicityDongxiang,
          l10n.ethnicityNaxi,
          l10n.ethnicityJingpo,
          l10n.ethnicityKirgiz,
          l10n.ethnicityTu,
          l10n.ethnicityDaur,
          l10n.ethnicityMulao,
          l10n.ethnicityQiang,
          l10n.ethnicityBlang,
          l10n.ethnicitySalar,
          l10n.ethnicityMaonan,
          l10n.ethnicityGelao,
          l10n.ethnicityXibe,
          l10n.ethnicityAchang,
          l10n.ethnicityPumi,
          l10n.ethnicityTajik,
          l10n.ethnicityNu,
          l10n.ethnicityUzbek,
          l10n.ethnicityRussian,
          l10n.ethnicityEwenki,
          l10n.ethnicityDeang,
          l10n.ethnicityBonan,
          l10n.ethnicityYugur,
          l10n.ethnicityGin,
          l10n.ethnicityTatar,
          l10n.ethnicityDerung,
          l10n.ethnicityOroqen,
          l10n.ethnicityHezhen,
          l10n.ethnicityMonba,
          l10n.ethnicityLhoba,
          l10n.ethnicityJino,
          l10n.ethnicityOther,
          l10n.ethnicityForeignBornChinese,
        ];
    }
  }
}
