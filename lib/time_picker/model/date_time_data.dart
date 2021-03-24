import 'package:flutter_pickers/time_picker/model/date_type.dart';

/// 时间选择器  item 生成的对应数据
class DateTimeData {
  List _year = [];
  List _month = [];
  List _day = [];
  List _hour = [];
  List _minute = [];
  List _second = [];

  List getListByName(DateType type) {
    switch (type) {
      case DateType.Year:
        return year;
      case DateType.Month:
        return month;
      case DateType.Day:
        return day;
      case DateType.Hour:
        return hour;
      case DateType.Minute:
        return minute;
      case DateType.Second:
        return second;
    }
  }

  List get year => _year;

  set year(List value) {
    _year.clear();
    _year.addAll(value);
  }

  List get month => _month;

  set month(List value) {
    _month.clear();
    _month.addAll(value);
  }

  List get second => _second;

  set second(List value) {
    _second.clear();
    _second.addAll(value);
  }

  List get minute => _minute;

  set minute(List value) {
    _minute.clear();
    _minute.addAll(value);
  }

  List get hour => _hour;

  set hour(List value) {
    _hour.clear();
    _hour.addAll(value);
  }

  List get day => _day;

  set day(List value) {
    _day.clear();
    _day.addAll(value);
  }
}
