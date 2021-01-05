///   时间选择器  默认 时间设置
///
///
///    var s = PDuration.now();
//     print('longer1 >>> ${s.toString()}');
//    {year: 2021, month: 1, day: 5, hour: 17, minute: 17, second: 3}
//
//     var m = PDuration(year: 2011);
//     print('longer2 >>> ${m.toString()}');
//      {year: 2011, month: null, day: null, hour: null, minute: null, second: null}
//
//     var d = PDuration.parse(DateTime.parse('20200304'));
//     print('longer3 >>> ${d.toString()}');
///     {year: 2020, month: 3, day: 4, hour: 0, minute: 0, second: 0}
///
class PDuration {
  int year;
  int month;
  int day;
  int hour;
  int minute;
  int second;

  PDuration({this.year, this.month, this.day, this.hour, this.minute, this.second});

  // 注意默认会设为0 不是null
  PDuration.parse(DateTime dateTime) {
    this.year = dateTime.year;
    this.month = dateTime.month;
    this.day = dateTime.day;
    this.hour = dateTime.hour;
    this.minute = dateTime.minute;
    this.second = dateTime.second;
  }

  PDuration.now() {
    var thisInstant = new DateTime.now();
    this.year = thisInstant.year;
    this.month = thisInstant.month;
    this.day = thisInstant.day;
    this.hour = thisInstant.hour;
    this.minute = thisInstant.minute;
    this.second = thisInstant.second;
  }

  @override
  String toString() {
    return 'PDuration{year: $year, month: $month, day: $day, hour: $hour, minute: $minute, second: $second}';
  }
}
