import 'package:flutter_pickers/time_picker/model/date_type.dart';

///   时间选择器  默认 时间设置
///
///
///    var s = PDuration.now();
///     debugPrint('longer1 >>> ${s.toString()}');
///    {year: 2021, month: 1, day: 5, hour: 17, minute: 17, second: 3}
///
///     var m = PDuration(year: 2011);
///     debugPrint('longer2 >>> ${m.toString()}');
///     {year: 2011, month: 0, day: 0, hour: 0, minute: 0, second: 0}
///
///     var d = PDuration.parse(DateTime.parse('20200304'));
///     debugPrint('longer3 >>> ${d.toString()}');
///     {year: 2020, month: 3, day: 4, hour: 0, minute: 0, second: 0}

bool intEmpty(int? value) {
  return (value == null || value == 0);
}

bool intNotEmpty(int? value) {
  return (value != null && value != 0);
}

class PDuration {
  int? year;
  int? month;
  int? day;
  int? hour;
  int? minute;
  int? second;

  PDuration({
    this.year = 0,
    this.month = 0,
    this.day = 0,
    this.hour = 0,
    this.minute = 0,
    this.second = 0,
  });

  // 注意默认会设为0 不是null
  PDuration.parse(DateTime dateTime) {
    year = dateTime.year;
    month = dateTime.month;
    day = dateTime.day;
    hour = dateTime.hour;
    minute = dateTime.minute;
    second = dateTime.second;
  }

  PDuration.now() {
    var thisInstant = DateTime.now();
    year = thisInstant.year;
    month = thisInstant.month;
    day = thisInstant.day;
    hour = thisInstant.hour;
    minute = thisInstant.minute;
    second = thisInstant.second;
  }

  void setSingle(DateType dateType, var value) {
    switch (dateType) {
      case DateType.Year:
        year = value;
        break;
      case DateType.Month:
        month = value;
        break;
      case DateType.Day:
        day = value;
        break;
      case DateType.Hour:
        hour = value;
        break;
      case DateType.Minute:
        minute = value;
        break;
      case DateType.Second:
        second = value;
        break;
    }
  }

  // 若为null 返回0
  int getSingle(DateType dateType) {
    switch (dateType) {
      case DateType.Year:
        return year ?? 0;
      case DateType.Month:
        return month ?? 0;
      case DateType.Day:
        return day ?? 0;
      case DateType.Hour:
        return hour ?? 0;
      case DateType.Minute:
        return minute ?? 0;
      case DateType.Second:
        return second ?? 0;
    }
  }

  @override
  String toString() {
    return 'PDuration{year: $year, month: $month, day: $day, hour: $hour, minute: $minute, second: $second}';
  }
}
