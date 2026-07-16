import 'package:flutter/material.dart';
import 'package:flutter_pickers/l10n/generated/app_localizations.dart';
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

  /// 从 BuildContext 获取国际化的 Suffix
  factory Suffix.fromContext(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return Suffix.normal();
    }
    return Suffix(
      years: l10n.year,
      month: l10n.month,
      days: l10n.day,
      hours: l10n.hour,
      minutes: l10n.minute,
      seconds: l10n.second,
    );
  }

  String getSingle(DateType dateType) {
    switch (dateType) {
      case DateType.year:
        return years;
      case DateType.month:
        return month;
      case DateType.day:
        return days;
      case DateType.hour:
        return hours;
      case DateType.minute:
        return minutes;
      case DateType.second:
        return seconds;
    }
  }
}
