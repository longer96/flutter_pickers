import 'dart:ui';

/// 选择器国际化语言管理类
///
/// 支持中英文切换，优先级：API 设置 > 系统语言 > 默认中文
class PickersLocale {
  static Locale? _overrideLocale;

  PickersLocale._();

  /// 设置语言（优先级高于系统设置）
  /// 仅支持 'zh' 和 'en'，传入其他值将被忽略
  static void setLocale(Locale? locale) {
    if (locale != null && !_isSupported(locale)) {
      return;
    }
    _overrideLocale = locale;
  }

  /// 获取当前语言
  static Locale? get currentLocale => _overrideLocale;

  /// 支持的语言列表
  static List<Locale> get supportedLocales => [
        const Locale('zh'),
        const Locale('en'),
      ];

  static bool _isSupported(Locale locale) {
    return locale.languageCode == 'zh' || locale.languageCode == 'en';
  }
}
