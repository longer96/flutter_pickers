
flutter_pickers
====
[![pub package](https://img.shields.io/pub/v/flutter_pickers.svg)](https://pub.dev/packages/flutter_pickers)  [![GitHub stars](https://img.shields.io/github/stars/longer96/flutter_pickers.svg?style=social)](https://github.com/longer96/flutter_pickers/stargazers)   [![GitHub forks](https://img.shields.io/github/forks/longer96/flutter_pickers.svg?style=social)](https://github.com/longer96/flutter_pickers/network)


flutter 选择器库，包括日期及时间选择器（可设置范围）、单项选择器（可用于性别、民族、学历、星座、年龄、身高、体重、温度等）、城市地址选择器（分省级、地级及县级）、多项选择器等…… 欢迎Fork & pr贡献您的代码，大家共同学习


## Example
[Web版在线Demo](https://longer96.github.io/flutter_pickers/)
<br>
flutter.eeaarr.cn (上面进不去 试试这个)


<br><br>
<img width="300px" style="max-width:100%;" src="https://github.com/longer96/flutter_pickers/blob/master/img/gif1.gif"/>  <img width="300px" style="max-width:100%;" src="https://github.com/longer96/flutter_pickers/blob/master/img/gif2.gif"/>
<br><br>
<img width="300px" style="max-width:100%;" src="https://github.com/longer96/flutter_pickers/blob/master/img/gif3.gif"/>  <img width="300px" style="max-width:100%;" src="https://github.com/longer96/flutter_pickers/blob/master/img/gif4.gif"/>


## 用法
1.Depend
``` pubspec.yaml
dependencies: 
    flutter_pickers: ^2.1.9
```

2.Get
```shell
$ flutter packages get
```

3.Install
```dart
import 'package:flutter_pickers/pickers.dart';
```



## 目录
- [flutter_pickers](#flutter_pickers)
  - [地址选择器](#地址选择器)
    - [简单使用](#简单使用)
    - [更多用法](#更多用法)
    - [更多方法](#更多方法)
  - [单项选择器](#单项选择器)
    - [简单使用](#简单使用.)
    - [内置数据](#内置数据)
  - [多项选择器（无联动）](#多项选择器（无联动）)
  - [多项选择器（联动）](#多项选择器（联动）)
  - [时间选择器](#时间选择器)
    - [简单使用](#简单使用..)
    - [更多方法](#更多方法.)
    - [参数说明](#参数说明)
    - [tip](#tip)
  - [样式](#样式)
    - [内置样式](#内置样式)
    - [自定义样式](#自定义样式)
  - [其他参数](#其他参数)
    - overlapTabBar
    
    
## 地址选择器
> Pickers.showAddressPicker()
- [区域数据来源](https://github.com/airyland/china-area-data)
- [请戳我查看demo代码](https://github.com/longer96/flutter_pickers/blob/master/example/lib/address_picker_page.dart)

* 支持三级联动
* 支持自定义颜色、大小等样式
* 支持显示 '全部' 选项
* 支持只选择 省市 2级
* 支持查询城市码
* 实时回调

| ![效果图1](https://github.com/longer96/flutter_pickers/blob/master/img/pic1.png)  | ![效果图2](https://github.com/longer96/flutter_pickers/blob/master/img/pic2.png) |
| :---------: | :------: |
| 三级选择器动图 | 二级静态图 |


### 简单使用
``` dart
String initProvince = '四川省', initCity = '成都市', initTown = '双流区';
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
* initTown : 不设置或者设置为null ，不显示区级



### 更多用法
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


| 参数         | 描述                  | 默认                 |
| ----------- | --------------------- | ------------------- |
| initProvince  | 初始化 省          | ''|
| initCity      | 初始化 市          | ''|
| initTown      | 初始化 区          | ''|
| pickerStyle   | 详见[样式](#样式)       | DefaultPickerStyle()|
| onChanged     | 选择器发生变动 return (String province, String city, String town)  | null|
| onConfirm     | 选择器提交 return (String province, String city, String town)| null|
| onCancel     | 选择器取消 return (bool isCancel) 是否通过点击取消按钮关闭| null|
|addAllItem|市、区是否添加 '全部' 选项|true|

### 更多方法
``` dart
/// 根据城市名 查询城市code(有先后顺序)
List<String> cityCode =  Address.getCityCodeByName(provinceName:'四川省', cityName: '成都市', townName: '武侯区');
return [510000,510100,510104]  or  [510000,510000]  or [510000]  or  []


/// 通过城市code 查询城市名(有先后顺序)
List<String> cityName =  Address.getCityNameByCode(provinceCode: "510000", cityCode: "510100", townCode: "510104");
return [四川省, 成都市, 锦江区]  or  [四川省, 成都市]  or [四川省] or []
```

## 单项选择器
> Pickers.showSinglePicker()[请戳我查看demo代码](https://github.com/longer96/flutter_pickers/blob/master/example/lib/single_picker_page.dart)

- 单选和多选支持数据源混传 num string


<br><br>
<img width="200px" style="max-width:100%;" src="https://github.com/longer96/flutter_pickers/blob/master/img/pic4.png"/>  <img width="200px" style="max-width:100%;" src="https://github.com/longer96/flutter_pickers/blob/master/img/pic5.png"/>  <img width="200px" style="max-width:100%;" src="https://github.com/longer96/flutter_pickers/blob/master/img/pic6.png"/>



### 简单使用.
``` dart
String initData = 'PHP';
Widget _demo() {
    return InkWell(
    onTap: () {
      Pickers.showSinglePicker(context,
          data: ['PHP', 'JAVA', 'C++', 'Dart', 'Python', 'Go'],
          selectData: initData,
          onConfirm: (p, position) {
            setState(() {
              initData = p;
            });
          }, onChanged: (p) => print('数据发生改变：$p'));
    },
    child: Text('$initData'));
}
```

| 参数         | 描述                  | 默认                 |
| ----------- | --------------------- | ------------------- |
| data        | 数据源                 | null|
| selectData  | 选中的数据              | ''|
| pickerStyle   | 详见[样式](#样式)     | DefaultPickerStyle()|
| onChanged     | 选择器发生变动 return (String data，int position)  | null|
| onConfirm     | 选择器提交 return (String data，int position)      | null|
| onCancel     | 选择器取消 return (bool isCancel) 是否通过点击取消按钮关闭 | null|


### 内置数据
> 可直接传给 data:PickerDataType.sex
- sex           // 性别
- education     // 学历
- subject       // 学科
- constellation // 星座
- zodiac        // 生肖
- ethnicity     // 民族


## 多项选择器（无联动）
> Pickers.showMultiPicker() [请戳我查看demo代码](https://github.com/longer96/flutter_pickers/blob/master/example/lib/multiple_picker_page.dart)


<br><br>
<img width="300px" style="max-width:100%;" src="https://github.com/longer96/flutter_pickers/blob/master/img/pic7.png"/>  <img width="300px" style="max-width:100%;" src="https://github.com/longer96/flutter_pickers/blob/master/img/pic8.png"/>

### 示例代码
``` dart
  final timeData = [
    ['上午', '下午'],
    List.generate(12, (index) => (index + 1).toString()).toList(),
    List.generate(60, (index) => index.toString()).toList(),
    List.generate(60, (index) => index.toString()).toList(),
  ];

  void _showDemo(){
    Pickers.showMultiPicker(
      context,
      data: timeData,
      selectData: timeData2Select,
      suffix: ['', '时', '分', '秒'],
      onConfirm: (p) {
        print('longer >>> 返回数据类型：${p.map((x) => x.runtimeType).toList()}');
      },
    );
  }
```

| 参数           | 描述                  | 默认                 |
| -----------   | --------------------- | ------------------- |
| data          | 数据源                 | null|
| selectData    | 选中的数据              | ''|
| suffix        | item后缀               | null|
| pickerStyle   | 详见[样式](#样式)       | DefaultPickerStyle()|
| onChanged     | 选择器发生变动 return (List data, List<int> position)  | null|
| onConfirm     | 选择器提交 return (List data, List<int> position)| null|
| onCancel      | 选择器取消 return (bool isCancel) 是否通过点击取消按钮关闭 | null|

<br>

## 多项选择器（联动）
> Pickers.showMultiLinkPicker() [请戳我查看demo代码](https://github.com/longer96/flutter_pickers/blob/master/example/lib/multiple_link_picker_page.dart)



### 示例代码
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
      onConfirm: (List p) {
        print('longer >>> 返回数据：${p.join('、')}');
        print('longer >>> 返回数据类型：${p.map((x) => x.runtimeType).toList()}');
      },
    );
  }
```

| 参数           | 描述                  | 默认                 |
| -----------   | --------------------- | ------------------- |
| columeNum     | 选择器列数（必填）       | null|
| data          | 数据源                 | null|

<br/>

* 和上面的多项选择器（无联动）差不多，就不多介绍，改动了2个字段
* 最外层必须是map（既然是多项，你至少得2列吧）
* map类型 说明还有下一列，如果是list或者string、num 表示已经达到最后一级




## 时间选择器
> Pickers.showDatePicker() [请戳我查看demo代码](https://github.com/longer96/flutter_pickers/blob/master/example/lib/date_picker_page.dart)

* 16种模式「年月日时分秒」
* 自定义后缀
* 最大|最小 时间
* 自定义显示样式


<br><br>
<img width="200px" style="max-width:100%;" src="https://github.com/longer96/flutter_pickers/blob/master/img/pic9.png"/>  <img width="200px" style="max-width:100%;" src="https://github.com/longer96/flutter_pickers/blob/master/img/pic10.png"/>  <img width="200px" style="max-width:100%;" src="https://github.com/longer96/flutter_pickers/blob/master/img/pic11.png"/>

<br><br>
<img width="200px" style="max-width:100%;" src="https://github.com/longer96/flutter_pickers/blob/master/img/pic12.png"/>  <img width="200px" style="max-width:100%;" src="https://github.com/longer96/flutter_pickers/blob/master/img/pic13.png"/>  <img width="200px" style="max-width:100%;" src="https://github.com/longer96/flutter_pickers/blob/master/img/pic14.png"/>


### 简单使用..
``` dart
Widget demo() {
    return FlatButton(
    onPressed: () {
      Pickers.showDatePicker(
        context,
        onConfirm: (p) {
          print('longer >>> 返回数据：$p');
        },
        // onChanged: (p) => print(p),
      );
    },
    child: Text('Demo'));
}
```

### 更多方法.
``` dart
    Pickers.showDatePicker(
      context,
      // 模式，详见下方
      mode: DateMode.HMS,
      // 后缀 默认Suffix.normal()，为空的话Suffix()
      suffix: Suffix(hours: ' 小时', minutes: ' 分钟', seconds: ' 秒'),
      // 样式  详见下方样式
      pickerStyle: pickerStyle,
      // 默认选中
      selectDate: PDuration(hour: 18, minute: 36, second: 36),
      minDate: PDuration(hour: 12, minute: 38, second: 3),
      maxDate: PDuration(hour: 12, minute: 40, second: 36),
      onConfirm: (p) {
        print('longer >>> 返回数据：$p');
      },
      // onChanged: (p) => print(p),
    );
```

| 参数         | 描述                  | 默认                 |
| ----------- | --------------------- | ------------------- |
| mode        | 时间选择器所显示样式  16 种时间样式| DateMode.YMD|
| selectData  | PDuration()初始化选中时间 | 默认现在：PDuration.now()|
| minDate       | PDuration()最小时间   | PDuration(year: 1900)|
| maxDate       | PDuration()最大时间   | PDuration(year: 2100)|
| suffix        | 每列时间对应的单位         | Suffix.normal()|
| pickerStyle   | 详见[样式](#样式)       | DefaultPickerStyle()|
| onChanged     | 选择器发生变动 return (PDuration data)  | null|
| onConfirm     | 选择器提交 return (PDuration data)| null|
| onCancel      | 选择器取消 return (bool isCancel) 是否通过点击取消按钮关闭 | null|


### 参数说明
- PDuration()
> selectDate，minDate，maxDate 和返回的数据类型 都是PDuration()
```
    // 可以自定义设置年月日时分秒
    PDuration(year: 2020, month: 1, day: 4, hour: 12, minute: 40, second: 36);
    // 设置DateTime类型
    PDuration.parse(DateTime.parse('20210139'));
    PDuration.now();
```

- DateMode
时间选择器所显示样式
```dart
  /// 时间选择器 所显示样式
  enum DateMode {
    /// 【yyyy-MM-dd HH:mm:ss】年月日时分秒
    YMDHMS,
    /// 【yyyy-MM-dd HH:mm】年月日时分
    YMDHM,  
    /// 【yyyy-MM-dd HH】年月日时
    YMDH,  
    /// 【yyyy-MM-dd】年月日
    YMD,  
    /// 【yyyy-MM】年月
    YM,  
    /// 【yyyy】年
    Y,  
    /// 【MM-dd HH:mm:ss】月日时分秒
    MDHMS,  
    /// 【MM-dd HH:mm】月日时分
    MDHM,  
    /// 【MM-dd HH:mm】月日时
    MDH,  
    /// 【MM-dd】月日
    MD,  
    /// 【HH:mm:ss】时分秒
    HMS,  
    /// 【HH:mm】时分
    HM,  
    /// 【mm:ss】分秒
    MS,  
    /// 【ss】秒
    S,  
    /// 【MM】月
    M,  
    /// 【HH】时
    H
  }
```


### tip
- 如果用到了日期，selectData需要传入年，不然无法计算，如果没有，会默认当前年
- 当只有单列数据，min|max限制不产生关联 只针对单列item限制，比如 maxDate: day=3, minDate: day=10, 那么day只显示3-10之间
- 如果minDate:year: 2020, month: 2, day: 10, 只显示2020年2月10日之后的
- minDate|maxDate 的YMD和HMS 没有关联！ 没有关联！比如设置maxDate:year: 2020, month: 2, day: 10, hour:8，不是2020年2月10日8时之后的时间


## 样式


### 内置样式
> style_picker_page.dart [请戳我查看demo代码](https://github.com/longer96/flutter_pickers/blob/master/example/lib/style_picker_page.dart)
> [default_style.dart 源码](https://github.com/longer96/flutter_pickers/blob/master/lib/style/default_style.dart)


- 以下4种样式是使用 PickerStyle 类进行封装的。
- 都内置了夜间模式，如 NoTitleStyle.dark()
- 除了NoTitleStyle, 其它的样式可以传入
  - haveRadius： 是否圆角  
  - title： 标题  
  - color： 确定按钮颜色


| ![样式1](https://github.com/longer96/flutter_pickers/blob/master/img/s1-1.png) | ![样式1](https://github.com/longer96/flutter_pickers/blob/master/img/s1-2.png) |
| :----------------------------------------------------------: | :----------------------------------------------------------: |
|                 默认样式：DefaultPickerStyle()                |              默认样式(暗色)：DefaultPickerStyle.dark()              |
|                                                              |                                                     |
| ![样式2](https://github.com/longer96/flutter_pickers/blob/master/img/s2-1.png) | ![样式2](https://github.com/longer96/flutter_pickers/blob/master/img/s2-2.png) |
|                 无标题样式：NoTitleStyle()                    |            无标题样式(暗色)：NoTitleStyle.dark()     |
|                                                              |                                                     |
| ![样式3](https://github.com/longer96/flutter_pickers/blob/master/img/s3-1.png) | ![样式3](https://github.com/longer96/flutter_pickers/blob/master/img/s3-2.png) |
|                 关闭按钮样式：ClosePickerStyle()               |            关闭按钮样式(暗色)：ClosePickerStyle.dark()          |
|                                                              |                                                     |
| ![样式4](https://github.com/longer96/flutter_pickers/blob/master/img/s4-1.png) | ![样式4](https://github.com/longer96/flutter_pickers/blob/master/img/s4-2.png) |
|                 圆角按钮样式：RaisedPickerStyle()               |            圆角按钮样式(暗色)：RaisedPickerStyle.dark()          |




### 自定义样式
> style_picker_page.dart [请戳我查看demo代码](https://github.com/longer96/flutter_pickers/blob/master/example/lib/style_picker_page.dart)
> picker_style.dart [样式基类](https://github.com/longer96/flutter_pickers/blob/master/lib/style/picker_style.dart)

<br>
<img width="600px" style="max-width:100%;" src="https://github.com/longer96/flutter_pickers/blob/master/img/style_mark.jpg"/>

```dart
/// [showTitleBar] 是否显示头部（选择器以上的控件） 默认：true
/// [menu] 头部和选择器之间的菜单widget，默认null 不显示
/// [title] 头部 中间的标题  默认SizedBox() 不显示
/// [pickerHeight] 选择器下面 picker 的整体高度  固定高度：220.0
/// [pickerTitleHeight]  选择器上面 title 确认、取消的整体高度  固定高度：44.0
/// [pickerItemHeight]  选择器每个被选中item的高度：40.0
/// [menuHeight]  头部和选择器之间的菜单高度  固定高度：36.0
/// [cancelButton]  头部的取消按钮
/// [commitButton]  头部的确认按钮
/// [textColor]  选择器的文字颜色 默认黑色
/// [textSize]  选择器的文字大小
/// [backgroundColor]  选择器的背景颜色 默认白色
/// [headDecoration] 头部Container 的Decoration   默认：BoxDecoration(color: Colors.white)
/// [itemOverlay] item的覆盖组件，可以自定义选中样式  [双横线样式可参考](https://github.com/longer96/flutter_pickers/issues/12)

class PickerStyle {}
```


## 其他参数

### [overlapTabBar](https://github.com/longer96/flutter_pickers/pull/16)
<img width="200px" style="max-width:100%;" src="https://github.com/longer96/flutter_pickers/blob/master/img/pic15.jpg"/>


## License
flutter_pickers 使用 MIT 许可证，详情见 [LICENSE](https://github.com/longer96/flutter_pickers/blob/master/LICENSE) 文件。
