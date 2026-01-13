class TimeUtils {
  /// 年
  static List calcYears({int begin = 1900, int end = 2100}) =>
      _calcCount(begin, end);

  /// 月
  static List calcMonth({int begin = 1, int end = 12}) {
    begin = begin < 1 ? 1 : begin;
    end = end > 12 ? 12 : end;
    return _calcCount(begin, end);
  }

  /// 日
  static List calcDay(int year, int month, {int begin = 1, int end = 31}) {
    begin = begin < 1 ? 1 : begin;

    int days = _calcDateCount(year, month);
    if (end > days) {
      end = days;
    }
    return _calcCount(begin, end);
  }

  /// 时
  static List calcHour({int begin = 0, int end = 23}) {
    begin = begin < 0 ? 0 : begin;
    end = end > 23 ? 23 : end;
    return _calcCount(begin, end);
  }

  /// 分 和 秒
  static List calcMinAndSecond({int begin = 0, int end = 59}) {
    begin = begin < 0 ? 0 : begin;
    end = end > 59 ? 59 : end;
    return _calcCount(begin, end);
  }

  static List _calcCount(begin, end) {
    int length = end - begin + 1;
    if (length == 0) return [begin];
    if (length < 0) return [];

    return List.generate(length, (index) => begin + index);
  }

  // 计算月份所对应天数
  static int _calcDateCount(int year, int month) {
    switch (month) {
      case 1:
      case 3:
      case 5:
      case 7:
      case 8:
      case 10:
      case 12:
        return 31;
      case 2:
        if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0) {
          return 29;
        }
        return 28;
    }
    return 30;
  }

  String intToStr(int v) {
    return (v < 10) ? "0$v" : "$v";
  }

  // String _checkStr(String v) {
  //   return v == null ? "" : v;
  // }
}
