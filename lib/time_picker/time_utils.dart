class TimeUtils {
  static List calcYears({begin = 1900, end = 2100}) => _calcDayCount(begin, end);

  static List calcMonth({begin = 1, end = 12}) => _calcDayCount(begin, end);

  // todo 开始结束时间
  static List calcDay(int year, int month) {
    // 正常
    int days = _calcDateCount(year, month);

    return List.generate(days, (index) =>  index + 1);
  }
  
  

  static List _calcDayCount(begin, end) {
    int days = end - begin;
    if (days == 0) return [begin];
    if (days < 0) return [];

    return List.generate(days, (index) => begin + index);
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
        {
          if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0) {
            return 29;
          }
          return 28;
        }
    }
    return 30;
  }

  String intToStr(int v) {
    return (v < 10) ? "0$v" : "$v";
  }

  String _checkStr(String v) {
    return v == null ? "" : v;
  }
}
