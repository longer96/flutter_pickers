// 是否需要 显示/设置  对应的选项
import 'package:flutter_pickers/time_picker/model/date_mode.dart';

class DateItemModel {
  late bool year;
  late bool month;
  late bool day;
  late bool hour;
  late bool minute;
  late bool second;

  DateItemModel(
    this.year,
    this.month,
    this.day,
    this.hour,
    this.minute,
    this.second,
  );

  DateItemModel.parse(DateMode dateMode) {
    year = dateModeMap[dateMode]!.contains('年');
    month = dateModeMap[dateMode]!.contains('月');
    day = dateModeMap[dateMode]!.contains('日');
    hour = dateModeMap[dateMode]!.contains('时');
    minute = dateModeMap[dateMode]!.contains('分');
    second = dateModeMap[dateMode]!.contains('秒');
  }

  // 返回需要显示多少个picker
  int get length {
    int i = 0;
    if (year) ++i;
    if (month) ++i;
    if (day) ++i;
    if (hour) ++i;
    if (minute) ++i;
    if (second) ++i;

    return i;
  }
}

const dateModeMap = {
  DateMode.YMDHMS: "年月日时分秒",
  DateMode.YMDHM: '年月日时分',
  DateMode.YMDH: '年月日时',
  DateMode.YMD: '年月日',
  DateMode.YM: '年月',
  DateMode.Y: '年',
  DateMode.MDHMS: '月日时分秒',
  DateMode.MDHM: '月日时分',
  DateMode.MDH: '月日时',
  DateMode.MD: '月日',
  DateMode.HMS: '时分秒',
  DateMode.HM: '时分',
  DateMode.MS: '分秒',
  DateMode.S: '秒',
  DateMode.M: '月',
  DateMode.H: '时',
};
