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

  String getSingle(DateType dateType) {
    return switch (dateType) {
      DateType.Year => years,
      DateType.Month => month,
      DateType.Day => days,
      DateType.Hour => hours,
      DateType.Minute => minutes,
      DateType.Second => seconds,
    };
  }
}
