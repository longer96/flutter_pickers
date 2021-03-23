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
      this.year, this.month, this.day, this.hour, this.minute, this.second);

  DateItemModel.parse(DateMode dateMode) {
    this.year = DateModeMap[dateMode]!.contains('年');
    this.month = DateModeMap[dateMode]!.contains('月');
    this.day = DateModeMap[dateMode]!.contains('日');
    this.hour = DateModeMap[dateMode]!.contains('时');
    this.minute = DateModeMap[dateMode]!.contains('分');
    this.second = DateModeMap[dateMode]!.contains('秒');
  }

  // 返回需要显示多少个picker
  int get length {
    int i = 0;
    if (this.year) ++i;
    if (this.month) ++i;
    if (this.day) ++i;
    if (this.hour) ++i;
    if (this.minute) ++i;
    if (this.second) ++i;

    return i;
  }
}

const DateModeMap = {
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
  DateMode.H: '时'
};
