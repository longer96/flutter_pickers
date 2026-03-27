# flutter_pickers 国际化实现计划

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 为 flutter_pickers 库添加中英文国际化支持，实现系统语言跟随和API手动控制。

**Architecture:** 使用 Flutter 官方 l10n 方案，通过 arb 文件管理翻译，生成 AppLocalizations 类。PickersLocale 类管理语言设置，各组件通过 BuildContext 获取本地化文本。

**Tech Stack:** Flutter, flutter_localizations, intl

---

## Chunk 1: 基础设施搭建

### Task 1: 更新依赖配置

**Files:**
- Modify: `pubspec.yaml`

- [ ] **Step 1: 添加国际化依赖**

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  intl: ^0.18.0
```

- [ ] **Step 2: 运行 flutter pub get**

Run: `flutter pub get`
Expected: Dependencies resolved successfully

- [ ] **Step 3: 提交**

```bash
git add pubspec.yaml pubspec.lock
git commit -m "chore: 添加国际化依赖"
```

### Task 2: 创建 l10n 配置

**Files:**
- Create: `lib/l10n/l10n.yaml`

- [ ] **Step 1: 创建 l10n.yaml 文件**

```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
output-class: AppLocalizations
output-dir: lib/l10n/generated
synthetic-package: false
```

- [ ] **Step 2: 提交**

```bash
git add lib/l10n/l10n.yaml
git commit -m "chore: 添加l10n配置文件"
```

### Task 3: 创建英文 ARB 文件（模板文件）

**Files:**
- Create: `lib/l10n/app_en.arb`

- [ ] **Step 1: 创建英文翻译文件**

```json
{
  "@@locale": "en",
  
  "cancel": "Cancel",
  "@cancel": {
    "description": "Cancel button text"
  },
  "confirm": "Confirm",
  "@confirm": {
    "description": "Confirm button text"
  },
  "year": "Year",
  "@year": {
    "description": "Year unit"
  },
  "month": "Month",
  "@month": {
    "description": "Month unit"
  },
  "day": "Day",
  "@day": {
    "description": "Day unit"
  },
  "hour": "Hour",
  "@hour": {
    "description": "Hour unit"
  },
  "minute": "Minute",
  "@minute": {
    "description": "Minute unit"
  },
  "second": "Second",
  "@second": {
    "description": "Second unit"
  },
  "all": "All",
  "@all": {
    "description": "All option in address picker"
  },
  
  "sexAny": "Any",
  "@sexAny": {
    "description": "Any gender option"
  },
  "sexMale": "Male",
  "@sexMale": {
    "description": "Male gender option"
  },
  "sexFemale": "Female",
  "@sexFemale": {
    "description": "Female gender option"
  },
  
  "educationBelowHighSchool": "Below High School",
  "@educationBelowHighSchool": {
    "description": "Education level below high school"
  },
  "educationHighSchool": "High School",
  "@educationHighSchool": {
    "description": "High school education"
  },
  "educationAssociate": "Associate",
  "@educationAssociate": {
    "description": "Associate degree"
  },
  "educationBachelor": "Bachelor",
  "@educationBachelor": {
    "description": "Bachelor degree"
  },
  "educationMaster": "Master",
  "@educationMaster": {
    "description": "Master degree"
  },
  "educationPhd": "PhD",
  "@educationPhd": {
    "description": "Doctorate degree"
  },
  "educationPostdoc": "Postdoc",
  "@educationPostdoc": {
    "description": "Postdoctoral"
  },
  "educationOther": "Other",
  "@educationOther": {
    "description": "Other education"
  },
  
  "subjectChinese": "Chinese",
  "subjectMath": "Math",
  "subjectEnglish": "English",
  "subjectPhysics": "Physics",
  "subjectChemistry": "Chemistry",
  "subjectBiology": "Biology",
  "subjectPolitics": "Politics",
  "subjectGeography": "Geography",
  "subjectHistory": "History",
  
  "constellationAquarius": "Aquarius",
  "constellationPisces": "Pisces",
  "constellationAries": "Aries",
  "constellationTaurus": "Taurus",
  "constellationGemini": "Gemini",
  "constellationCancer": "Cancer",
  "constellationLeo": "Leo",
  "constellationVirgo": "Virgo",
  "constellationLibra": "Libra",
  "constellationScorpio": "Scorpio",
  "constellationSagittarius": "Sagittarius",
  "constellationCapricorn": "Capricorn",
  
  "zodiacRat": "Rat",
  "zodiacOx": "Ox",
  "zodiacTiger": "Tiger",
  "zodiacRabbit": "Rabbit",
  "zodiacDragon": "Dragon",
  "zodiacSnake": "Snake",
  "zodiacHorse": "Horse",
  "zodiacGoat": "Goat",
  "zodiacMonkey": "Monkey",
  "zodiacRooster": "Rooster",
  "zodiacDog": "Dog",
  "zodiacPig": "Pig",
  
  "ethnicityHan": "Han",
  "ethnicityMongol": "Mongol",
  "ethnicityHui": "Hui",
  "ethnicityTibetan": "Tibetan",
  "ethnicityUygur": "Uygur",
  "ethnicityMiao": "Miao",
  "ethnicityYi": "Yi",
  "ethnicityZhuang": "Zhuang",
  "ethnicityBouyei": "Bouyei",
  "ethnicityKorean": "Korean",
  "ethnicityManchu": "Manchu",
  "ethnicityDong": "Dong",
  "ethnicityYao": "Yao",
  "ethnicityBai": "Bai",
  "ethnicityTujia": "Tujia",
  "ethnicityHani": "Hani",
  "ethnicityKazak": "Kazak",
  "ethnicityDai": "Dai",
  "ethnicityLi": "Li",
  "ethnicityLisu": "Lisu",
  "ethnicityVa": "Va",
  "ethnicityShe": "She",
  "ethnicityGaoshan": "Gaoshan",
  "ethnicityLahu": "Lahu",
  "ethnicityShui": "Shui",
  "ethnicityDongxiang": "Dongxiang",
  "ethnicityNaxi": "Naxi",
  "ethnicityJingpo": "Jingpo",
  "ethnicityKirgiz": "Kirgiz",
  "ethnicityTu": "Tu",
  "ethnicityDaur": "Daur",
  "ethnicityMulao": "Mulao",
  "ethnicityQiang": "Qiang",
  "ethnicityBlang": "Blang",
  "ethnicitySalar": "Salar",
  "ethnicityMaonan": "Maonan",
  "ethnicityGelao": "Gelao",
  "ethnicityXibe": "Xibe",
  "ethnicityAchang": "Achang",
  "ethnicityPumi": "Pumi",
  "ethnicityTajik": "Tajik",
  "ethnicityNu": "Nu",
  "ethnicityUzbek": "Uzbek",
  "ethnicityRussian": "Russian",
  "ethnicityEwenki": "Ewenki",
  "ethnicityDeang": "Deang",
  "ethnicityBonan": "Bonan",
  "ethnicityYugur": "Yugur",
  "ethnicityGin": "Gin",
  "ethnicityTatar": "Tatar",
  "ethnicityDerung": "Derung",
  "ethnicityOroqen": "Oroqen",
  "ethnicityHezhen": "Hezhen",
  "ethnicityMonba": "Monba",
  "ethnicityLhoba": "Lhoba",
  "ethnicityJino": "Jino",
  "ethnicityOther": "Other",
  "ethnicityForeignBornChinese": "Foreign-born Chinese"
}
```

- [ ] **Step 2: 提交**

```bash
git add lib/l10n/app_en.arb
git commit -m "feat: 添加英文翻译文件"
```

### Task 4: 创建中文 ARB 文件

**Files:**
- Create: `lib/l10n/app_zh.arb`

- [ ] **Step 1: 创建中文翻译文件**

```json
{
  "@@locale": "zh",
  
  "cancel": "取消",
  "confirm": "确定",
  "year": "年",
  "month": "月",
  "day": "日",
  "hour": "时",
  "minute": "分",
  "second": "秒",
  "all": "全部",
  
  "sexAny": "不限",
  "sexMale": "男",
  "sexFemale": "女",
  
  "educationBelowHighSchool": "高中以下",
  "educationHighSchool": "高中",
  "educationAssociate": "大专",
  "educationBachelor": "本科",
  "educationMaster": "硕士",
  "educationPhd": "博士",
  "educationPostdoc": "博士后",
  "educationOther": "其它",
  
  "subjectChinese": "语文",
  "subjectMath": "数学",
  "subjectEnglish": "英语",
  "subjectPhysics": "物理",
  "subjectChemistry": "化学",
  "subjectBiology": "生物",
  "subjectPolitics": "政治",
  "subjectGeography": "地理",
  "subjectHistory": "历史",
  
  "constellationAquarius": "水瓶座",
  "constellationPisces": "双鱼座",
  "constellationAries": "白羊座",
  "constellationTaurus": "金牛座",
  "constellationGemini": "双子座",
  "constellationCancer": "巨蟹座",
  "constellationLeo": "狮子座",
  "constellationVirgo": "处女座",
  "constellationLibra": "天秤座",
  "constellationScorpio": "天蝎座",
  "constellationSagittarius": "射手座",
  "constellationCapricorn": "摩羯座",
  
  "zodiacRat": "鼠",
  "zodiacOx": "牛",
  "zodiacTiger": "虎",
  "zodiacRabbit": "兔",
  "zodiacDragon": "龙",
  "zodiacSnake": "蛇",
  "zodiacHorse": "马",
  "zodiacGoat": "羊",
  "zodiacMonkey": "猴",
  "zodiacRooster": "鸡",
  "zodiacDog": "狗",
  "zodiacPig": "猪",
  
  "ethnicityHan": "汉族",
  "ethnicityMongol": "蒙古族",
  "ethnicityHui": "回族",
  "ethnicityTibetan": "藏族",
  "ethnicityUygur": "维吾尔族",
  "ethnicityMiao": "苗族",
  "ethnicityYi": "彝族",
  "ethnicityZhuang": "壮族",
  "ethnicityBouyei": "布依族",
  "ethnicityKorean": "朝鲜族",
  "ethnicityManchu": "满族",
  "ethnicityDong": "侗族",
  "ethnicityYao": "瑶族",
  "ethnicityBai": "白族",
  "ethnicityTujia": "土家族",
  "ethnicityHani": "哈尼族",
  "ethnicityKazak": "哈萨克族",
  "ethnicityDai": "傣族",
  "ethnicityLi": "黎族",
  "ethnicityLisu": "傈僳族",
  "ethnicityVa": "佤族",
  "ethnicityShe": "畲族",
  "ethnicityGaoshan": "高山族",
  "ethnicityLahu": "拉祜族",
  "ethnicityShui": "水族",
  "ethnicityDongxiang": "东乡族",
  "ethnicityNaxi": "纳西族",
  "ethnicityJingpo": "景颇族",
  "ethnicityKirgiz": "柯尔克孜族",
  "ethnicityTu": "土族",
  "ethnicityDaur": "达斡尔族",
  "ethnicityMulao": "仫佬族",
  "ethnicityQiang": "羌族",
  "ethnicityBlang": "布朗族",
  "ethnicitySalar": "撒拉族",
  "ethnicityMaonan": "毛难族",
  "ethnicityGelao": "仡佬族",
  "ethnicityXibe": "锡伯族",
  "ethnicityAchang": "阿昌族",
  "ethnicityPumi": "普米族",
  "ethnicityTajik": "塔吉克族",
  "ethnicityNu": "怒族",
  "ethnicityUzbek": "乌孜别克族",
  "ethnicityRussian": "俄罗斯族",
  "ethnicityEwenki": "鄂温克族",
  "ethnicityDeang": "崩龙族",
  "ethnicityBonan": "保安族",
  "ethnicityYugur": "裕固族",
  "ethnicityGin": "京族",
  "ethnicityTatar": "塔塔尔族",
  "ethnicityDerung": "独龙族",
  "ethnicityOroqen": "鄂伦春族",
  "ethnicityHezhen": "赫哲族",
  "ethnicityMonba": "门巴族",
  "ethnicityLhoba": "珞巴族",
  "ethnicityJino": "基诺族",
  "ethnicityOther": "其他",
  "ethnicityForeignBornChinese": "外国血统中国人士"
}
```

- [ ] **Step 2: 提交**

```bash
git add lib/l10n/app_zh.arb
git commit -m "feat: 添加中文翻译文件"
```

### Task 5: 生成国际化代码

**Files:**
- Generate: `lib/l10n/generated/app_localizations.dart`
- Generate: `lib/l10n/generated/app_localizations_en.dart`
- Generate: `lib/l10n/generated/app_localizations_zh.dart`

- [ ] **Step 1: 创建 generated 目录**

```bash
mkdir -p lib/l10n/generated
```

- [ ] **Step 2: 运行代码生成**

Run: `flutter gen-l10n`
Expected: Generated files in lib/l10n/generated/

- [ ] **Step 3: 验证生成文件存在**

Run: `ls lib/l10n/generated/`
Expected: app_localizations.dart, app_localizations_en.dart, app_localizations_zh.dart

- [ ] **Step 4: 提交**

```bash
git add lib/l10n/generated/
git commit -m "feat: 生成国际化代码"
```

---

## Chunk 2: PickersLocale 类和 getData 方法

### Task 6: 创建 PickersLocale 类

**Files:**
- Create: `lib/pickers_locale.dart`

- [ ] **Step 1: 创建 PickersLocale 类**

```dart
import 'dart:ui';

class PickersLocale {
  static Locale? _overrideLocale;

  PickersLocale._();

  static void setLocale(Locale? locale) {
    if (locale != null && !_isSupported(locale)) {
      return;
    }
    _overrideLocale = locale;
  }

  static Locale? get currentLocale => _overrideLocale;

  static List<Locale> get supportedLocales => [
    const Locale('zh'),
    const Locale('en'),
  ];

  static bool _isSupported(Locale locale) {
    return locale.languageCode == 'zh' || locale.languageCode == 'en';
  }
}
```

- [ ] **Step 2: 提交**

```bash
git add lib/pickers_locale.dart
git commit -m "feat: 添加 PickersLocale 语言管理类"
```

### Task 7: 在 pickers.dart 中添加 getData 方法

**Files:**
- Modify: `lib/pickers.dart`

- [ ] **Step 1: 验证 init_data.dart 中的类型**

确认 `pickerData` Map 和 `PickerDataType` 枚举存在且格式正确。

Run: `grep -n "pickerData\|PickerDataType" lib/more_pickers/init_data.dart`
Expected: 找到 `PickerDataType` 枚举定义和 `pickerData` Map 定义

- [ ] **Step 2: 添加导入和 getData 方法**

在文件顶部添加导入：

```dart
import 'package:flutter_pickers/l10n/generated/app_localizations.dart';
import 'package:flutter_pickers/more_pickers/init_data.dart';
```

在 `Pickers` 类中添加方法：

```dart
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

static List<String> _getLocalizedData(PickerDataType type, AppLocalizations l10n) {
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
```

- [ ] **Step 2: 提交**

```bash
git add lib/pickers.dart
git commit -m "feat: 添加 getData 方法支持国际化内置数据"
```

---

## Chunk 3: Route 文件国际化改造

### Task 8: 改造 Suffix 类支持国际化

**Files:**
- Modify: `lib/time_picker/model/suffix.dart`

- [ ] **Step 1: 添加 fromContext 工厂构造函数**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_pickers/l10n/generated/app_localizations.dart';
import 'package:flutter_pickers/time_picker/model/date_type.dart';

class Suffix {
  late String years;
  late String month;
  late String days;
  late String hours;
  late String minutes;
  late String seconds;

  Suffix.normal() {
    years = '年';
    month = '月';
    days = '日';
    hours = '时';
    minutes = '分';
    seconds = '秒';
  }

  Suffix({
    this.years = '',
    this.month = '',
    this.days = '',
    this.hours = '',
    this.minutes = '',
    this.seconds = '',
  });

  factory Suffix.fromContext(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return Suffix.normal();
    }
    return Suffix(
      years: l10n.year,
      month: l10n.month,
      days: l10n.day,
      hours: l10n.hour,
      minutes: l10n.minute,
      seconds: l10n.second,
    );
  }

  String getSingle(DateType dateType) {
    switch (dateType) {
      case DateType.year:
        return years;
      case DateType.month:
        return month;
      case DateType.day:
        return days;
      case DateType.hour:
        return hours;
      case DateType.minute:
        return minutes;
      case DateType.second:
        return seconds;
    }
  }
}
```

- [ ] **Step 2: 提交**

```bash
git add lib/time_picker/model/suffix.dart
git commit -m "feat: Suffix 类支持国际化"
```

### Task 9: 改造 date_picker_route.dart

**Files:**
- Modify: `lib/time_picker/route/date_picker_route.dart`

- [ ] **Step 1: 在 _PickerState 中添加 late Suffix _suffix 属性**

在 `_PickerState` 类中（约 line 127），找到其他 late 属性定义位置，添加：

```dart
late Suffix _suffix;
```

- [ ] **Step 2: 在 initState 中初始化 _suffix**

在 `initState` 方法中添加：

```dart
_suffix = widget.route.suffix ?? Suffix.fromContext(context);
```

- [ ] **Step 3: 修改 line 805 使用 _suffix**

将：
```dart
'${_dateTimeData.getListByName(dateType)[index]}${widget.route.suffix?.getSingle(dateType)}'
```

改为：
```dart
'${_dateTimeData.getListByName(dateType)[index]}${_suffix.getSingle(dateType)}'
```

- [ ] **Step 4: 提交**

```bash
git add lib/time_picker/route/date_picker_route.dart
git commit -m "feat: 时间选择器支持国际化"
```

### Task 10: 改造 address_picker_route.dart

**Files:**
- Modify: `lib/address_picker/route/address_picker_route.dart`

**说明：** 根据设计要求，城市名称始终显示中文，不做国际化。只有"全部"选项需要国际化。

- [ ] **Step 1: 添加导入**

```dart
import 'package:flutter_pickers/l10n/generated/app_localizations.dart';
```

- [ ] **Step 2: 修改"全部"文本获取**

找到使用"全部"文本的地方，改为：

```dart
final l10n = AppLocalizations.of(context);
final allText = l10n?.all ?? '全部';
```

- [ ] **Step 3: 提交**

```bash
git add lib/address_picker/route/address_picker_route.dart
git commit -m "feat: 地址选择器支持国际化"
```

---

## Chunk 4: 样式国际化

### Task 11: 改造 picker_style.dart

**Files:**
- Modify: `lib/style/picker_style.dart`

- [ ] **Step 1: 添加导入**

```dart
import 'package:flutter_pickers/l10n/generated/app_localizations.dart';
```

- [ ] **Step 2: 修改 getCommitButton 方法**

```dart
Widget getCommitButton() {
  if (_commitButton != null) return _commitButton!;
  
  final l10n = context != null ? AppLocalizations.of(context!) : null;
  final text = l10n?.confirm ?? '确定';
  
  final primaryColor = context != null 
      ? Theme.of(context!).primaryColor 
      : Colors.blue;
  
  return Container(
    alignment: Alignment.center,
    padding: const EdgeInsets.only(left: 12, right: 22),
    child: Text(
      text,
      style: TextStyle(
        color: primaryColor,
        fontSize: 16.0,
      ),
    ),
  );
}
```

- [ ] **Step 3: 修改 getCancelButton 方法**

```dart
Widget getCancelButton() {
  if (_cancelButton != null) return _cancelButton!;
  
  final l10n = context != null ? AppLocalizations.of(context!) : null;
  final text = l10n?.cancel ?? '取消';
  
  final unselectedColor = context != null
      ? Theme.of(context!).unselectedWidgetColor
      : Colors.grey;
  
  return Container(
    alignment: Alignment.center,
    padding: const EdgeInsets.only(left: 22, right: 12),
    child: Text(
      text,
      style: TextStyle(
        color: unselectedColor,
        fontSize: 16.0,
      ),
    ),
  );
}
```

- [ ] **Step 4: 提交**

```bash
git add lib/style/picker_style.dart
git commit -m "feat: 选择器样式支持国际化"
```

### Task 12: 改造 default_style.dart

**Files:**
- Modify: `lib/style/default_style.dart`

**说明：** `default_style.dart` 中的样式类（DefaultPickerStyle.dark、RaisedPickerStyle 等）直接设置了 `commitButton` 和 `cancelButton`，绕过了 `getCommitButton()` 方法。有两种处理方式：

1. **推荐方案**：保持现状，因为这些样式是预设样式，用户如果需要国际化，可以不使用这些预设样式，而是自定义 `PickerStyle` 或使用默认样式。

2. **替代方案**：移除所有预设样式中直接设置 `commitButton`/`cancelButton` 的代码，让它们通过 `getCommitButton()`/`getCancelButton()` 获取国际化文本。

采用**推荐方案**：保持现状，在文档中说明预设样式不支持国际化。

- [ ] **Step 1: 添加注释说明**

在 `default_style.dart` 文件顶部添加：

```dart
// 注意：预设样式（如 DefaultPickerStyle.dark、RaisedPickerStyle 等）
// 中的按钮文本为固定中文，不支持国际化。
// 如需国际化，请使用默认样式或自定义 PickerStyle。
```

- [ ] **Step 2: 提交**

```bash
git add lib/style/default_style.dart
git commit -m "docs: 添加预设样式国际化说明"
```

---

## Chunk 5: 导出和文档更新

### Task 13: 更新 pickers.dart 导出

**Files:**
- Modify: `lib/pickers.dart`

- [ ] **Step 1: 添加 PickersLocale 导出**

```dart
export 'pickers_locale.dart';
export 'l10n/generated/app_localizations.dart';
```

- [ ] **Step 2: 提交**

```bash
git add lib/pickers.dart
git commit -m "feat: 导出 PickersLocale 和 AppLocalizations"
```

### Task 14: 更新 README.md

**Files:**
- Modify: `README.md`

- [ ] **Step 1: 在 README.md 中添加国际化说明**

在"用法"部分后添加：

```markdown
## 国际化

本库支持中英文国际化。

### 使用方式

#### 1. 在 MaterialApp 中配置

```dart
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

MaterialApp(
  localizationsDelegates: [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ],
  supportedLocales: AppLocalizations.supportedLocales,
);
```

#### 2. API 控制语言（可选）

```dart
// 设置英文
PickersLocale.setLocale(Locale('en'));

// 设置中文
PickersLocale.setLocale(Locale('zh'));

// 恢复跟随系统
PickersLocale.setLocale(null);
```

#### 3. 获取国际化内置数据

```dart
// 旧方式（返回中文）
PickerDataType.sex

// 新方式（支持国际化）
final sexData = Pickers.getData(PickerDataType.sex, context);
```

**注意：** 预设样式（如 `DefaultPickerStyle.dark()`、`RaisedPickerStyle()` 等）中的按钮文本为固定中文，不支持国际化。如需国际化，请使用默认样式或自定义 `PickerStyle`。
```

- [ ] **Step 2: 提交**

```bash
git add README.md
git commit -m "docs: 更新中文国际化文档"
```

### Task 15: 更新 README-EN.md

**Files:**
- Modify: `README-EN.md`

- [ ] **Step 1: 添加国际化说明（英文版）**

```markdown
## Internationalization

This library supports Chinese and English internationalization.

### Usage

#### 1. Configure in MaterialApp

```dart
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

MaterialApp(
  localizationsDelegates: [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ],
  supportedLocales: AppLocalizations.supportedLocales,
);
```

#### 2. API Control (Optional)

```dart
// Set English
PickersLocale.setLocale(Locale('en'));

// Set Chinese
PickersLocale.setLocale(Locale('zh'));

// Reset to follow system
PickersLocale.setLocale(null);
```

#### 3. Get Localized Built-in Data

```dart
// Old way (returns Chinese)
PickerDataType.sex

// New way (supports i18n)
final sexData = Pickers.getData(PickerDataType.sex, context);
```

**Note:** Preset styles (e.g., `DefaultPickerStyle.dark()`, `RaisedPickerStyle()`) have fixed Chinese button text and do not support i18n. For i18n support, use the default style or customize `PickerStyle`.
```

- [ ] **Step 2: 提交**

```bash
git add README-EN.md
git commit -m "docs: update i18n documentation in English"
```

### Task 16: 更新 CHANGELOG

**Files:**
- Modify: `CHANGELOG.md`

- [ ] **Step 1: 添加版本更新记录**

```markdown
## 2.3.0

- feat: 添加国际化支持（中英文）
- feat: 新增 PickersLocale 类管理语言设置
- feat: 新增 Pickers.getData() 方法获取国际化内置数据
- feat: 时间选择器、地址选择器、样式支持国际化
- feat: Suffix 类新增 fromContext 工厂构造函数支持国际化
```

- [ ] **Step 2: 提交**

```bash
git add CHANGELOG.md
git commit -m "docs: 更新 CHANGELOG"
```

---

## Chunk 6: 测试

**说明：** 本计划包含单元测试覆盖核心功能。Widget 测试和集成测试可作为后续任务，因为它们需要更完整的 Flutter 测试环境设置。

### Task 17: 编写 PickersLocale 单元测试

**Files:**
- Modify: `test/flutter_picker_test.dart`

- [ ] **Step 1: 添加 PickersLocale 测试**

```dart
import 'dart:ui';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PickersLocale', () {
    setUp(() {
      PickersLocale.setLocale(null);
    });

    test('setLocale with zh returns zh', () {
      PickersLocale.setLocale(const Locale('zh'));
      expect(PickersLocale.currentLocale?.languageCode, 'zh');
    });

    test('setLocale with en returns en', () {
      PickersLocale.setLocale(const Locale('en'));
      expect(PickersLocale.currentLocale?.languageCode, 'en');
    });

    test('setLocale with unsupported locale is ignored', () {
      PickersLocale.setLocale(const Locale('ja'));
      expect(PickersLocale.currentLocale, isNull);
    });

    test('setLocale with null resets to null', () {
      PickersLocale.setLocale(const Locale('en'));
      PickersLocale.setLocale(null);
      expect(PickersLocale.currentLocale, isNull);
    });

    test('supportedLocales contains zh and en', () {
      final locales = PickersLocale.supportedLocales;
      expect(locales.any((l) => l.languageCode == 'zh'), isTrue);
      expect(locales.any((l) => l.languageCode == 'en'), isTrue);
    });
  });
}
```

- [ ] **Step 2: 运行测试**

Run: `flutter test test/flutter_picker_test.dart`
Expected: All tests pass

- [ ] **Step 3: 提交**

```bash
git add test/flutter_picker_test.dart
git commit -m "test: 添加 PickersLocale 单元测试"
```

---

## Chunk 7: 最终验证

### Task 18: 运行静态分析

- [ ] **Step 1: 运行 flutter analyze**

Run: `flutter analyze`
Expected: No issues found

如果发现问题，修复后再继续。

### Task 19: 运行所有测试

- [ ] **Step 1: 运行测试**

Run: `flutter test`
Expected: All tests pass

### Task 20: 更新 pubspec.yaml 版本

**Files:**
- Modify: `pubspec.yaml`

- [ ] **Step 1: 更新版本号**

将版本从 `2.2.0` 改为 `2.3.0`

- [ ] **Step 2: 提交**

```bash
git add pubspec.yaml
git commit -m "chore: 更新版本到 2.3.0"
```

### Task 21: 最终提交

- [ ] **Step 1: 查看所有更改**

Run: `git log --oneline -20`
Expected: 所有任务都已提交

- [ ] **Step 2: 推送到远程（可选）**

```bash
git push origin master
```

---

## 验收清单

- [ ] flutter pub get 成功
- [ ] flutter gen-l10n 成功生成国际化代码
- [ ] 所有选择器在中英文环境下正常显示
- [ ] PickersLocale.setLocale() 正常工作
- [ ] Pickers.getData() 返回正确的国际化数据
- [ ] 现有 API 保持向后兼容
- [ ] 无国际化配置时，行为与之前一致