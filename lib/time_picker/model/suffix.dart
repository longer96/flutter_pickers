/// 后缀标签
class Suffix {
  String years = '年';
  String month = '月';
  String days = '日';
  String hours = '时';
  String minutes = '分';
  String seconds = '秒';

  static Suffix noSuffix = Suffix(years: '', month: '', days: '', hours: '', minutes: '', seconds: '');

  Suffix({this.years, this.month, this.days, this.hours, this.minutes, this.seconds});
}
