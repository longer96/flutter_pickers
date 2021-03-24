import 'package:flutter_pickers/time_picker/model/date_type.dart';

/// 后缀标签
class Suffix {
  late String years;
  late String month;
  late String days;
  late String hours;
  late String minutes;
  late String seconds;

  Suffix.normal() {
    this.years = '年';
    this.month = '月';
    this.days = '日';
    this.hours = '时';
    this.minutes = '分';
    this.seconds = '秒';
  }

  Suffix({this.years: '', this.month: '', this.days: '', this.hours: '', this.minutes: '', this.seconds: ''});

  String getSingle(DateType dateType) {
    switch (dateType) {
      case DateType.Year:
        return this.years;
      case DateType.Month:
        return this.month;
      case DateType.Day:
        return this.days;
      case DateType.Hour:
        return this.hours;
      case DateType.Minute:
        return this.minutes;
      case DateType.Second:
        return this.seconds;
    }
  }
}
