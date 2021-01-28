flutter_pickers
====

flutter 选择器类库，包括日期及时间选择器（可设置范围）、单项选择器（可用于性别、职业、学历、星座等）、城市地址选择器（分省级、地级及县级）、数字选择器（可用于年龄、身高、体重、温度等）等…… 欢迎Fork & pr贡献您的代码，大家共同学习

[![pub package](https://img.shields.io/pub/v/flutter_pickers.svg)](https://pub.dev/packages/flutter_pickers)  [![GitHub stars](https://img.shields.io/github/stars/longer96/flutter_pickers.svg?style=social)](https://github.com/longer96/flutter_pickers/stargazers)   [![GitHub forks](https://img.shields.io/github/forks/longer96/flutter_pickers.svg?style=social)](https://github.com/longer96/flutter_pickers/network)
## Getting Started


## 导入

Depend
``` pubspec.yaml
dependencies: 
    flutter_pickers: ^1.0.0
```

Install
```shell
$ flutter packages get
```

文档语言: [English](README-EN.md) | [中文简体](README.md)


## 目录

- [flutter_pickers](#flutter_pickers)
  - [地址选择器](#地址选择器)
    - [简单使用](#简单使用)
    - [更多用法](#更多用法)
    - [更多方法](#更多方法)
  - [单项选择器](#单项选择器)
    - [简单使用](#simple use)
    - [内置数据](#内置数据)
  - [多项选择器](#单项选择器)
  - [时间选择器](#时间选择器)
    - [简单使用](#简单使用)
    - [模式](#模式)
    - [tip](#tip)
  - [样式](#样式)
    - [内置样式](#内置样式)
    - [自定义样式](#自定义样式)
    
    
## 地址选择器

### 简单使用
<br>

> Pickers.showAddressPicker()
[区域数据来源](https://github.com/airyland/china-area-data)
[请戳我查看demo代码](https://github.com/longer96/flutter_pickers/blob/master/example/lib/address_picker_page.dart)

* 支持三级联动
* 支持自定义颜色、大小等样式
* 支持显示 '全部' 选项
* 支持只选择 省市 2级
* 支持查询城市码
* 实时回调


#### simple use
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

| ![效果图1](https://github.com/longer96/flutter_pickers/blob/master/img/p1.gif) | ![效果图2](https://github.com/longer96/flutter_pickers/blob/master/img/p2.gif) |
| :----------------------------------------------------------: | :----------------------------------------------------------: |
|                     三级选择器动图                      |                     二级静态图                      |



#### 更多用法
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


<br><br><img width="300px" style="max-width:100%;" src="https://github.com/longer96/flutter_pickers/blob/master/img/p3.jpg"/>


| 参数         | 描述                  | 默认                 |
| ----------- | --------------------- | ------------------- |
| initProvince  | 初始化 省          | ''|
| initCity      | 初始化 市          | ''|
| initTown      | 初始化 区          | ''|
| pickerStyle   | 详见[样式](#样式)       | DefaultPickerStyle()|
| onChanged     | 选择器发生变动 return (String province, String city, String town)  | null|
| onConfirm     | 选择器提交 return (String province, String city, String town)| null|
|addAllItem|市、区是否添加 '全部' 选项|true|

### 更多方法
``` dart
/// 根据城市名 查询城市code(有先后顺序)
List<String> cityCode =  Locations.getTownsCityCode("四川省","成都市","锦江区");
return [510000,510100,510104]  or  [510000,510000]  or [510000]  or  []


/// 通过城市code 查询城市名(有先后顺序)
List<String> cityName =  Locations.getCityNameByCode("510000","510100","510104");
return [四川省, 成都市, 锦江区]  or  [四川省, 成都市]  or [四川省] or []
```


## 单项选择器

> Pickers.showAddressPicker()[请戳我查看demo代码](https://github.com/longer96/flutter_pickers/blob/master/example/lib/single_picker_page.dart)

### simple use

``` dart
String initData = 'PHP';
  Widget _demo() {
    return InkWell(
        onTap: () {
          Pickers.showSinglePicker(context,
              data: ['PHP', 'JAVA', 'C++', 'Dart', 'Python', 'Go'],
              selectData: initData,
              onConfirm: (p) {
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
| selectData  | 选中的数据          | ''|
| pickerStyle   | 详见[样式](#样式)       | DefaultPickerStyle()|
| onChanged     | 选择器发生变动 return (String data)  | null|
| onConfirm     | 选择器提交 return (String data)| null|


### 内置数据
> 可直接传给 data:PickerDataType.sex
- sex, // 性别
- education, // 学历
- subject, // 学科
- constellation, // 星座
- zodiac, // 生肖
- ethnicity, // 名族


## 多项选择器






## License
flutter_pickers 使用 MIT 许可证，详情见 [LICENSE](https://github.com/longer96/flutter_pickers/blob/master/LICENSE) 文件。









