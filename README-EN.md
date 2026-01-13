
flutter_pickers
====
[![pub package](https://img.shields.io/pub/v/flutter_pickers.svg)](https://pub.dev/packages/flutter_pickers)  [![GitHub stars](https://img.shields.io/github/stars/longer96/flutter_pickers.svg?style=social)](https://github.com/longer96/flutter_pickers/stargazers)   [![GitHub forks](https://img.shields.io/github/forks/longer96/flutter_pickers.svg?style=social)](https://github.com/longer96/flutter_pickers/network)


Flutter picker library including date & time picker (with range setting), single item picker (for gender, ethnicity, education, constellation, age, height, weight, temperature, etc.), city address picker (province, city and county levels), multiple pickers and more... Welcome to Fork & PR to contribute your code, let's learn together!


## Example
[Web Demo](https://longer96.github.io/flutter_pickers/)
<br>
flutter.eeaarr.cn (Try this if the above doesn't work)


<br><br>
<img width="300px" style="max-width:100%;" src="https://github.com/longer96/flutter_pickers/blob/master/img/gif1.gif"/>  <img width="300px" style="max-width:100%;" src="https://github.com/longer96/flutter_pickers/blob/master/img/gif2.gif"/>
<br><br>
<img width="300px" style="max-width:100%;" src="https://github.com/longer96/flutter_pickers/blob/master/img/gif3.gif"/>  <img width="300px" style="max-width:100%;" src="https://github.com/longer96/flutter_pickers/blob/master/img/gif4.gif"/>


## Usage
1.Depend
``` pubspec.yaml
dependencies: 
    flutter_pickers: ^2.2.0
```

2.Get
```shell
$ flutter packages get
```

3.Install
```dart
import 'package:flutter_pickers/pickers.dart';
```



## Table of Contents
- [flutter_pickers](#flutter_pickers)
  - [Address Picker](#address-picker)
    - [Simple Usage](#simple-usage)
    - [Advanced Usage](#advanced-usage)
    - [More Methods](#more-methods)
  - [Single Picker](#single-picker)
    - [Simple Usage](#simple-usage-1)
    - [Built-in Data](#built-in-data)
  - [Multiple Picker (No Linkage)](#multiple-picker-no-linkage)
  - [Multiple Picker (With Linkage)](#multiple-picker-with-linkage)
  - [Date/Time Picker](#datetime-picker)
    - [Simple Usage](#simple-usage-2)
    - [Advanced Methods](#advanced-methods)
    - [Parameter Description](#parameter-description)
    - [Tips](#tips)
  - [Styles](#styles)
    - [Built-in Styles](#built-in-styles)
    - [Custom Styles](#custom-styles)
  - [Other Parameters](#other-parameters)
    - overlapTabBar
    
    
## Address Picker
> Pickers.showAddressPicker()
- [Area data source](https://github.com/airyland/china-area-data)
- [Check demo code here](https://github.com/longer96/flutter_pickers/blob/master/example/lib/address_picker_page.dart)

* Supports three-level linkage
* Supports custom colors, sizes and other styles
* Supports displaying 'All' option
* Supports selecting only 2 levels (province and city)
* Supports querying city codes
* Real-time callback

|| ![Screenshot 1](https://github.com/longer96/flutter_pickers/blob/master/img/pic1.png)  | ![Screenshot 2](https://github.com/longer96/flutter_pickers/blob/master/img/pic2.png) |
|| :---------: | :------: |
|| Three-level Picker | Two-level Picker |


### Simple Usage
``` dart
String initProvince = 'Sichuan', initCity = 'Chengdu', initTown = 'Shuangliu';
Widget _checkLocation() {
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
            initTown = t;
          });
        },
      );
    },
    child: Text('$initProvince - $initCity - $initTown'));
}
```
* initTown: If not set or set to null, county/district level will not be displayed



### Advanced Usage
> demo [address_picker_page.dart](https://github.com/longer96/flutter_pickers/blob/master/example/lib/address_picker_page.dart)

``` dart
AddressPicker.showPicker(
  context,
  initProvince: locations2[0],
  initCity: locations2[1],
  initTown: locations2[2],
  showTitlebar: true,
  menu: _headMenuView,
  menuHeight: 36.0,
  title: title,
  cancelWidget: _cancelButton,
  commitWidget: _commitButton,
  headDecoration: headDecoration,
  addAllItem: false,
  textColor: Colors.white,
  backgroundColor: Colors.grey[800],
  onConfirm: (p, c, t) {},
);
```
<br>
<img width="350px" style="max-width:100%;" src="https://github.com/longer96/flutter_pickers/blob/master/img/pic3.png"/>


| Parameter | Description | Default |
| ----------- | --------------------- | ------------------- |
| initProvince  | Initialize province | ''|
| initCity      | Initialize city | ''|
| initTown      | Initialize county/district | ''|
| pickerStyle   | See [Styles](#styles) | DefaultPickerStyle()|
| onChanged     | Callback when picker changes, returns (String province, String city, String town)  | null|
| onConfirm     | Callback when picker confirms, returns (String province, String city, String town)| null|
| onCancel     | Callback when picker cancels, returns (bool isCancel) whether closed by cancel button | null|
|addAllItem| Whether to add 'All' option for city and county/district |true|

### More Methods
``` dart
/// Query city code by city name (in order)
List<String> cityCode = Address.getCityCodeByName(
  provinceName: 'Sichuan', 
  cityName: 'Chengdu', 
  townName: 'Wuhou'
);
// returns [510000,510100,510104] or [510000,510000] or [510000] or []


/// Query city name by city code (in order)
List<String> cityName = Address.getCityNameByCode(
  provinceCode: "510000", 
  cityCode: "510100", 
  townCode: "510104"
);
// returns [Sichuan, Chengdu, Jinjiang] or [Sichuan, Chengdu] or [Sichuan] or []
```

## Single Picker
> Pickers.showSinglePicker() [Check demo code here](https://github.com/longer96/flutter_pickers/blob/master/example/lib/single_picker_page.dart)

- Single and multiple pickers support mixed data source of num and string


<br><br>
<img width="200px" style="max-width:100%;" src="https://github.com/longer96/flutter_pickers/blob/master/img/pic4.png"/>  <img width="200px" style="max-width:100%;" src="https://github.com/longer96/flutter_pickers/blob/master/img/pic5.png"/>  <img width="200px" style="max-width:100%;" src="https://github.com/longer96/flutter_pickers/blob/master/img/pic6.png"/>



### Simple Usage
``` dart
String initData = 'PHP';
Widget _demo() {
  return InkWell(
    onTap: () {
      Pickers.showSinglePicker(
        context,
        data: ['PHP', 'JAVA', 'C++', 'Dart', 'Python', 'Go'],
        selectData: initData,
        onConfirm: (p, position) {
          setState(() {
            initData = p;
          });
        }, 
        onChanged: (p) => debugPrint('Data changed: $p')
      );
    },
    child: Text('$initData')
  );
}
```

| Parameter | Description | Default |
| ----------- | --------------------- | ------------------- |
| data        | Data source | null|
| selectData  | Selected data | ''|
| pickerStyle | See [Styles](#styles) | DefaultPickerStyle()|
| onChanged   | Callback when picker changes, returns (String data, int position) | null|
| onConfirm   | Callback when picker confirms, returns (String data, int position) | null|
| onCancel    | Callback when picker cancels, returns (bool isCancel) whether closed by cancel button | null|


### Built-in Data
> Can be directly passed to data: PickerDataType.sex
- sex           // Gender
- education     // Education
- subject       // Subject
- constellation // Constellation
- zodiac        // Zodiac
- ethnicity     // Ethnicity


## Multiple Picker (No Linkage)
> Pickers.showMultiPicker() [Check demo code here](https://github.com/longer96/flutter_pickers/blob/master/example/lib/multiple_picker_page.dart)


<br><br>
<img width="300px" style="max-width:100%;" src="https://github.com/longer96/flutter_pickers/blob/master/img/pic7.png"/>  <img width="300px" style="max-width:100%;" src="https://github.com/longer96/flutter_pickers/blob/master/img/pic8.png"/>

### Example Code
``` dart
final timeData = [
  ['AM', 'PM'],
  List.generate(12, (index) => (index + 1).toString()).toList(),
  List.generate(60, (index) => index.toString()).toList(),
  List.generate(60, (index) => index.toString()).toList(),
];

void _showDemo(){
  Pickers.showMultiPicker(
    context,
    data: timeData,
    selectData: timeData2Select,
    suffix: ['', 'h', 'm', 's'],
    onConfirm: (p) {
      debugPrint('Returned data types: ${p.map((x) => x.runtimeType).toList()}');
    },
  );
}
```

| Parameter | Description | Default |
| ----------- | --------------------- | ------------------- |
| data        | Data source | null|
| selectData  | Selected data | ''|
| suffix      | Item suffix | null|
| pickerStyle | See [Styles](#styles) | DefaultPickerStyle()|
| onChanged   | Callback when picker changes, returns (List data, List<int> position) | null|
| onConfirm   | Callback when picker confirms, returns (List data, List<int> position)| null|
| onCancel    | Callback when picker cancels, returns (bool isCancel) whether closed by cancel button | null|

<br>

## Multiple Picker (With Linkage)
> Pickers.showMultiLinkPicker() [Check demo code here](https://github.com/longer96/flutter_pickers/blob/master/example/lib/multiple_link_picker_page.dart)



### Example Code
``` dart
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
          'ccccc4': 'Please star',
          'ccc4-2': [4442, 44442, 442]
        },
      },
      'cc2': ['ccc', 123],
      'cc3': 'star to encourage'
    }
  };

  Pickers.showMultiLinkPicker(
    context,
    data: multiData,
    // Note: data types must match. For example, if 44442 is written as string '44442', it won't be found
    // selectData: ['c', 'cc', 'cccc33', 'ccc4-2', 44442],
    selectData: ['c', 'cc3'],
    columnNum: 5,
    suffix: ['', '', '', '', ''],
    onConfirm: (List p) {
      debugPrint('Returned data: ${p.join('、')}');
      debugPrint('Returned data types: ${p.map((x) => x.runtimeType).toList()}');
    },
  );
}
```

| Parameter | Description | Default |
|-----------| --------------------- | ------------------- |
| columnNum | Number of picker columns (required) | null|
| data      | Data source | null|

<br/>

* Similar to the multiple picker (no linkage) above, just modified 2 fields
* The outermost layer must be a map (since it's multiple, you need at least 2 columns)
* Map type indicates there's another column, if it's list or string/num, it means the last level has been reached




## Date/Time Picker
> Pickers.showDatePicker() [Check demo code here](https://github.com/longer96/flutter_pickers/blob/master/example/lib/date_picker_page.dart)

* 16 modes 「Year-Month-Day-Hour-Minute-Second」
* Custom suffix
* Maximum|Minimum time
* Custom display style


<br><br>
<img width="200px" style="max-width:100%;" src="https://github.com/longer96/flutter_pickers/blob/master/img/pic9.png"/>  <img width="200px" style="max-width:100%;" src="https://github.com/longer96/flutter_pickers/blob/master/img/pic10.png"/>  <img width="200px" style="max-width:100%;" src="https://github.com/longer96/flutter_pickers/blob/master/img/pic11.png"/>

<br><br>
<img width="200px" style="max-width:100%;" src="https://github.com/longer96/flutter_pickers/blob/master/img/pic12.png"/>  <img width="200px" style="max-width:100%;" src="https://github.com/longer96/flutter_pickers/blob/master/img/pic13.png"/>  <img width="200px" style="max-width:100%;" src="https://github.com/longer96/flutter_pickers/blob/master/img/pic14.png"/>


### Simple Usage
``` dart
Widget demo() {
  return TextButton(
    onPressed: () {
      Pickers.showDatePicker(
        context,
        onConfirm: (p) {
          print('Returned data: $p');
        },
        // onChanged: (p) => print(p),
      );
    },
    child: Text('Demo')
  );
}
```

### Advanced Methods
``` dart
Pickers.showDatePicker(
  context,
  // Mode, see below
  mode: DateMode.HMS,
  // Suffix, default is Suffix.normal(), use Suffix() for empty
  suffix: Suffix(hours: ' hour', minutes: ' min', seconds: ' sec'),
  // Style, see styles below
  pickerStyle: pickerStyle,
  // Default selection
  selectDate: PDuration(hour: 18, minute: 36, second: 36),
  minDate: PDuration(hour: 12, minute: 38, second: 3),
  maxDate: PDuration(hour: 12, minute: 40, second: 36),
  onConfirm: (p) {
    print('Returned data: $p');
  },
  // onChanged: (p) => print(p),
);
```

| Parameter | Description | Default |
| ----------- | --------------------- | ------------------- |
| mode        | Time picker display style, 16 time styles | DateMode.YMD|
| selectData  | PDuration() initialize selected time | Default now: PDuration.now()|
| minDate     | PDuration() minimum time | PDuration(year: 1900)|
| maxDate     | PDuration() maximum time | PDuration(year: 2100)|
| suffix      | Unit corresponding to each column of time | Suffix.normal()|
| pickerStyle | See [Styles](#styles) | DefaultPickerStyle()|
| onChanged   | Callback when picker changes, returns (PDuration data) | null|
| onConfirm   | Callback when picker confirms, returns (PDuration data)| null|
| onCancel    | Callback when picker cancels, returns (bool isCancel) whether closed by cancel button | null|


### Parameter Description
- PDuration()
> selectDate, minDate, maxDate and returned data type are all PDuration()
```dart
// Can customize year, month, day, hour, minute, second
PDuration(year: 2020, month: 1, day: 4, hour: 12, minute: 40, second: 36);
// Set DateTime type
PDuration.parse(DateTime.parse('20210101'));
PDuration.now();
```

- DateMode
Time picker display styles
```dart
/// Time picker display styles
enum DateMode {
  /// 【yyyy-MM-dd HH:mm:ss】Year-Month-Day-Hour-Minute-Second
  YMDHMS,
  /// 【yyyy-MM-dd HH:mm】Year-Month-Day-Hour-Minute
  YMDHM,  
  /// 【yyyy-MM-dd HH】Year-Month-Day-Hour
  YMDH,  
  /// 【yyyy-MM-dd】Year-Month-Day
  YMD,  
  /// 【yyyy-MM】Year-Month
  YM,  
  /// 【yyyy】Year
  Y,  
  /// 【MM-dd HH:mm:ss】Month-Day-Hour-Minute-Second
  MDHMS,  
  /// 【MM-dd HH:mm】Month-Day-Hour-Minute
  MDHM,  
  /// 【MM-dd HH:mm】Month-Day-Hour
  MDH,  
  /// 【MM-dd】Month-Day
  MD,  
  /// 【HH:mm:ss】Hour-Minute-Second
  HMS,  
  /// 【HH:mm】Hour-Minute
  HM,  
  /// 【mm:ss】Minute-Second
  MS,  
  /// 【ss】Second
  S,  
  /// 【MM】Month
  M,  
  /// 【HH】Hour
  H
}
```


### Tips
- If date is used, selectData needs to pass in year, otherwise it cannot be calculated. If not provided, defaults to current year
- When there's only single column data, min|max restrictions don't create linkage, only restrict single column items. For example, maxDate: day=3, minDate: day=10, then day only shows between 3-10
- If minDate: year: 2020, month: 2, day: 10, only dates after February 10, 2020 are displayed
- minDate|maxDate's YMD and HMS have no linkage! No linkage! For example, setting maxDate: year: 2020, month: 2, day: 10, hour: 8, does not mean times after 8 o'clock on February 10, 2020


## Styles


### Built-in Styles
> style_picker_page.dart [Check demo code here](https://github.com/longer96/flutter_pickers/blob/master/example/lib/style_picker_page.dart)
> [default_style.dart source code](https://github.com/longer96/flutter_pickers/blob/master/lib/style/default_style.dart)


- The following 4 styles are encapsulated using the PickerStyle class
- All have built-in dark mode, such as NoTitleStyle.dark()
- Except NoTitleStyle, other styles can accept parameters:
  - haveRadius: Whether to have rounded corners  
  - title: Title  
  - color: Confirm button color


|| ![Style 1](https://github.com/longer96/flutter_pickers/blob/master/img/s1-1.png) | ![Style 1](https://github.com/longer96/flutter_pickers/blob/master/img/s1-2.png) |
|| :----------------------------------------------------------: | :----------------------------------------------------------: |
|| Default Style: DefaultPickerStyle() | Default Style (Dark): DefaultPickerStyle.dark() |
||                                                              |                                                     |
|| ![Style 2](https://github.com/longer96/flutter_pickers/blob/master/img/s2-1.png) | ![Style 2](https://github.com/longer96/flutter_pickers/blob/master/img/s2-2.png) |
|| No Title Style: NoTitleStyle() | No Title Style (Dark): NoTitleStyle.dark() |
||                                                              |                                                     |
|| ![Style 3](https://github.com/longer96/flutter_pickers/blob/master/img/s3-1.png) | ![Style 3](https://github.com/longer96/flutter_pickers/blob/master/img/s3-2.png) |
|| Close Button Style: ClosePickerStyle() | Close Button Style (Dark): ClosePickerStyle.dark() |
||                                                              |                                                     |
|| ![Style 4](https://github.com/longer96/flutter_pickers/blob/master/img/s4-1.png) | ![Style 4](https://github.com/longer96/flutter_pickers/blob/master/img/s4-2.png) |
|| Raised Button Style: RaisedPickerStyle() | Raised Button Style (Dark): RaisedPickerStyle.dark() |




### Custom Styles
> style_picker_page.dart [Check demo code here](https://github.com/longer96/flutter_pickers/blob/master/example/lib/style_picker_page.dart)
> picker_style.dart [Style base class](https://github.com/longer96/flutter_pickers/blob/master/lib/style/picker_style.dart)

<br>
<img width="600px" style="max-width:100%;" src="https://github.com/longer96/flutter_pickers/blob/master/img/style_mark.jpg"/>

```dart
/// [showTitleBar] Whether to show header (widgets above picker), default: true
/// [menu] Menu widget between header and picker, default null (not displayed)
/// [title] Title in the middle of header, default SizedBox() (not displayed)
/// [pickerHeight] Overall height of picker below, fixed height: 220.0
/// [pickerTitleHeight] Overall height of title area above picker (confirm/cancel), fixed height: 44.0
/// [pickerItemHeight] Height of each selected item in picker: 40.0
/// [menuHeight] Menu height between header and picker, fixed height: 36.0
/// [cancelButton] Cancel button in header
/// [commitButton] Confirm button in header
/// [textColor] Text color of picker, default black
/// [textSize] Text size of picker
/// [backgroundColor] Background color of picker, default white
/// [headDecoration] Decoration of header container, default: BoxDecoration(color: Colors.white)
/// [itemOverlay] Overlay component for items, can customize selected style [See double line style reference](https://github.com/longer96/flutter_pickers/issues/12)

class PickerStyle {}
```


## Other Parameters

### [overlapTabBar](https://github.com/longer96/flutter_pickers/pull/16)
<img width="200px" style="max-width:100%;" src="https://github.com/longer96/flutter_pickers/blob/master/img/pic15.jpg"/>


## License
flutter_pickers uses the MIT license, see [LICENSE](https://github.com/longer96/flutter_pickers/blob/master/LICENSE) file for details.

---

**Documentation Language**: [English](README-EN.md) | [中文简体](README.md)
