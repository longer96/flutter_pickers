import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh')
  ];

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Confirm button text
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Year unit
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// Month unit
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get month;

  /// Day unit
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get day;

  /// Hour unit
  ///
  /// In en, this message translates to:
  /// **'Hour'**
  String get hour;

  /// Minute unit
  ///
  /// In en, this message translates to:
  /// **'Minute'**
  String get minute;

  /// Second unit
  ///
  /// In en, this message translates to:
  /// **'Second'**
  String get second;

  /// All option in address picker
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// Any gender option
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get sexAny;

  /// Male gender option
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get sexMale;

  /// Female gender option
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get sexFemale;

  /// Education level below high school
  ///
  /// In en, this message translates to:
  /// **'Below High School'**
  String get educationBelowHighSchool;

  /// High school education
  ///
  /// In en, this message translates to:
  /// **'High School'**
  String get educationHighSchool;

  /// Associate degree
  ///
  /// In en, this message translates to:
  /// **'Associate'**
  String get educationAssociate;

  /// Bachelor degree
  ///
  /// In en, this message translates to:
  /// **'Bachelor'**
  String get educationBachelor;

  /// Master degree
  ///
  /// In en, this message translates to:
  /// **'Master'**
  String get educationMaster;

  /// Doctorate degree
  ///
  /// In en, this message translates to:
  /// **'PhD'**
  String get educationPhd;

  /// Postdoctoral
  ///
  /// In en, this message translates to:
  /// **'Postdoc'**
  String get educationPostdoc;

  /// Other education
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get educationOther;

  /// No description provided for @subjectChinese.
  ///
  /// In en, this message translates to:
  /// **'Chinese'**
  String get subjectChinese;

  /// No description provided for @subjectMath.
  ///
  /// In en, this message translates to:
  /// **'Math'**
  String get subjectMath;

  /// No description provided for @subjectEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get subjectEnglish;

  /// No description provided for @subjectPhysics.
  ///
  /// In en, this message translates to:
  /// **'Physics'**
  String get subjectPhysics;

  /// No description provided for @subjectChemistry.
  ///
  /// In en, this message translates to:
  /// **'Chemistry'**
  String get subjectChemistry;

  /// No description provided for @subjectBiology.
  ///
  /// In en, this message translates to:
  /// **'Biology'**
  String get subjectBiology;

  /// No description provided for @subjectPolitics.
  ///
  /// In en, this message translates to:
  /// **'Politics'**
  String get subjectPolitics;

  /// No description provided for @subjectGeography.
  ///
  /// In en, this message translates to:
  /// **'Geography'**
  String get subjectGeography;

  /// No description provided for @subjectHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get subjectHistory;

  /// No description provided for @constellationAquarius.
  ///
  /// In en, this message translates to:
  /// **'Aquarius'**
  String get constellationAquarius;

  /// No description provided for @constellationPisces.
  ///
  /// In en, this message translates to:
  /// **'Pisces'**
  String get constellationPisces;

  /// No description provided for @constellationAries.
  ///
  /// In en, this message translates to:
  /// **'Aries'**
  String get constellationAries;

  /// No description provided for @constellationTaurus.
  ///
  /// In en, this message translates to:
  /// **'Taurus'**
  String get constellationTaurus;

  /// No description provided for @constellationGemini.
  ///
  /// In en, this message translates to:
  /// **'Gemini'**
  String get constellationGemini;

  /// No description provided for @constellationCancer.
  ///
  /// In en, this message translates to:
  /// **'Cancer'**
  String get constellationCancer;

  /// No description provided for @constellationLeo.
  ///
  /// In en, this message translates to:
  /// **'Leo'**
  String get constellationLeo;

  /// No description provided for @constellationVirgo.
  ///
  /// In en, this message translates to:
  /// **'Virgo'**
  String get constellationVirgo;

  /// No description provided for @constellationLibra.
  ///
  /// In en, this message translates to:
  /// **'Libra'**
  String get constellationLibra;

  /// No description provided for @constellationScorpio.
  ///
  /// In en, this message translates to:
  /// **'Scorpio'**
  String get constellationScorpio;

  /// No description provided for @constellationSagittarius.
  ///
  /// In en, this message translates to:
  /// **'Sagittarius'**
  String get constellationSagittarius;

  /// No description provided for @constellationCapricorn.
  ///
  /// In en, this message translates to:
  /// **'Capricorn'**
  String get constellationCapricorn;

  /// No description provided for @zodiacRat.
  ///
  /// In en, this message translates to:
  /// **'Rat'**
  String get zodiacRat;

  /// No description provided for @zodiacOx.
  ///
  /// In en, this message translates to:
  /// **'Ox'**
  String get zodiacOx;

  /// No description provided for @zodiacTiger.
  ///
  /// In en, this message translates to:
  /// **'Tiger'**
  String get zodiacTiger;

  /// No description provided for @zodiacRabbit.
  ///
  /// In en, this message translates to:
  /// **'Rabbit'**
  String get zodiacRabbit;

  /// No description provided for @zodiacDragon.
  ///
  /// In en, this message translates to:
  /// **'Dragon'**
  String get zodiacDragon;

  /// No description provided for @zodiacSnake.
  ///
  /// In en, this message translates to:
  /// **'Snake'**
  String get zodiacSnake;

  /// No description provided for @zodiacHorse.
  ///
  /// In en, this message translates to:
  /// **'Horse'**
  String get zodiacHorse;

  /// No description provided for @zodiacGoat.
  ///
  /// In en, this message translates to:
  /// **'Goat'**
  String get zodiacGoat;

  /// No description provided for @zodiacMonkey.
  ///
  /// In en, this message translates to:
  /// **'Monkey'**
  String get zodiacMonkey;

  /// No description provided for @zodiacRooster.
  ///
  /// In en, this message translates to:
  /// **'Rooster'**
  String get zodiacRooster;

  /// No description provided for @zodiacDog.
  ///
  /// In en, this message translates to:
  /// **'Dog'**
  String get zodiacDog;

  /// No description provided for @zodiacPig.
  ///
  /// In en, this message translates to:
  /// **'Pig'**
  String get zodiacPig;

  /// No description provided for @ethnicityHan.
  ///
  /// In en, this message translates to:
  /// **'Han'**
  String get ethnicityHan;

  /// No description provided for @ethnicityMongol.
  ///
  /// In en, this message translates to:
  /// **'Mongol'**
  String get ethnicityMongol;

  /// No description provided for @ethnicityHui.
  ///
  /// In en, this message translates to:
  /// **'Hui'**
  String get ethnicityHui;

  /// No description provided for @ethnicityTibetan.
  ///
  /// In en, this message translates to:
  /// **'Tibetan'**
  String get ethnicityTibetan;

  /// No description provided for @ethnicityUygur.
  ///
  /// In en, this message translates to:
  /// **'Uygur'**
  String get ethnicityUygur;

  /// No description provided for @ethnicityMiao.
  ///
  /// In en, this message translates to:
  /// **'Miao'**
  String get ethnicityMiao;

  /// No description provided for @ethnicityYi.
  ///
  /// In en, this message translates to:
  /// **'Yi'**
  String get ethnicityYi;

  /// No description provided for @ethnicityZhuang.
  ///
  /// In en, this message translates to:
  /// **'Zhuang'**
  String get ethnicityZhuang;

  /// No description provided for @ethnicityBouyei.
  ///
  /// In en, this message translates to:
  /// **'Bouyei'**
  String get ethnicityBouyei;

  /// No description provided for @ethnicityKorean.
  ///
  /// In en, this message translates to:
  /// **'Korean'**
  String get ethnicityKorean;

  /// No description provided for @ethnicityManchu.
  ///
  /// In en, this message translates to:
  /// **'Manchu'**
  String get ethnicityManchu;

  /// No description provided for @ethnicityDong.
  ///
  /// In en, this message translates to:
  /// **'Dong'**
  String get ethnicityDong;

  /// No description provided for @ethnicityYao.
  ///
  /// In en, this message translates to:
  /// **'Yao'**
  String get ethnicityYao;

  /// No description provided for @ethnicityBai.
  ///
  /// In en, this message translates to:
  /// **'Bai'**
  String get ethnicityBai;

  /// No description provided for @ethnicityTujia.
  ///
  /// In en, this message translates to:
  /// **'Tujia'**
  String get ethnicityTujia;

  /// No description provided for @ethnicityHani.
  ///
  /// In en, this message translates to:
  /// **'Hani'**
  String get ethnicityHani;

  /// No description provided for @ethnicityKazak.
  ///
  /// In en, this message translates to:
  /// **'Kazak'**
  String get ethnicityKazak;

  /// No description provided for @ethnicityDai.
  ///
  /// In en, this message translates to:
  /// **'Dai'**
  String get ethnicityDai;

  /// No description provided for @ethnicityLi.
  ///
  /// In en, this message translates to:
  /// **'Li'**
  String get ethnicityLi;

  /// No description provided for @ethnicityLisu.
  ///
  /// In en, this message translates to:
  /// **'Lisu'**
  String get ethnicityLisu;

  /// No description provided for @ethnicityVa.
  ///
  /// In en, this message translates to:
  /// **'Va'**
  String get ethnicityVa;

  /// No description provided for @ethnicityShe.
  ///
  /// In en, this message translates to:
  /// **'She'**
  String get ethnicityShe;

  /// No description provided for @ethnicityGaoshan.
  ///
  /// In en, this message translates to:
  /// **'Gaoshan'**
  String get ethnicityGaoshan;

  /// No description provided for @ethnicityLahu.
  ///
  /// In en, this message translates to:
  /// **'Lahu'**
  String get ethnicityLahu;

  /// No description provided for @ethnicityShui.
  ///
  /// In en, this message translates to:
  /// **'Shui'**
  String get ethnicityShui;

  /// No description provided for @ethnicityDongxiang.
  ///
  /// In en, this message translates to:
  /// **'Dongxiang'**
  String get ethnicityDongxiang;

  /// No description provided for @ethnicityNaxi.
  ///
  /// In en, this message translates to:
  /// **'Naxi'**
  String get ethnicityNaxi;

  /// No description provided for @ethnicityJingpo.
  ///
  /// In en, this message translates to:
  /// **'Jingpo'**
  String get ethnicityJingpo;

  /// No description provided for @ethnicityKirgiz.
  ///
  /// In en, this message translates to:
  /// **'Kirgiz'**
  String get ethnicityKirgiz;

  /// No description provided for @ethnicityTu.
  ///
  /// In en, this message translates to:
  /// **'Tu'**
  String get ethnicityTu;

  /// No description provided for @ethnicityDaur.
  ///
  /// In en, this message translates to:
  /// **'Daur'**
  String get ethnicityDaur;

  /// No description provided for @ethnicityMulao.
  ///
  /// In en, this message translates to:
  /// **'Mulao'**
  String get ethnicityMulao;

  /// No description provided for @ethnicityQiang.
  ///
  /// In en, this message translates to:
  /// **'Qiang'**
  String get ethnicityQiang;

  /// No description provided for @ethnicityBlang.
  ///
  /// In en, this message translates to:
  /// **'Blang'**
  String get ethnicityBlang;

  /// No description provided for @ethnicitySalar.
  ///
  /// In en, this message translates to:
  /// **'Salar'**
  String get ethnicitySalar;

  /// No description provided for @ethnicityMaonan.
  ///
  /// In en, this message translates to:
  /// **'Maonan'**
  String get ethnicityMaonan;

  /// No description provided for @ethnicityGelao.
  ///
  /// In en, this message translates to:
  /// **'Gelao'**
  String get ethnicityGelao;

  /// No description provided for @ethnicityXibe.
  ///
  /// In en, this message translates to:
  /// **'Xibe'**
  String get ethnicityXibe;

  /// No description provided for @ethnicityAchang.
  ///
  /// In en, this message translates to:
  /// **'Achang'**
  String get ethnicityAchang;

  /// No description provided for @ethnicityPumi.
  ///
  /// In en, this message translates to:
  /// **'Pumi'**
  String get ethnicityPumi;

  /// No description provided for @ethnicityTajik.
  ///
  /// In en, this message translates to:
  /// **'Tajik'**
  String get ethnicityTajik;

  /// No description provided for @ethnicityNu.
  ///
  /// In en, this message translates to:
  /// **'Nu'**
  String get ethnicityNu;

  /// No description provided for @ethnicityUzbek.
  ///
  /// In en, this message translates to:
  /// **'Uzbek'**
  String get ethnicityUzbek;

  /// No description provided for @ethnicityRussian.
  ///
  /// In en, this message translates to:
  /// **'Russian'**
  String get ethnicityRussian;

  /// No description provided for @ethnicityEwenki.
  ///
  /// In en, this message translates to:
  /// **'Ewenki'**
  String get ethnicityEwenki;

  /// No description provided for @ethnicityDeang.
  ///
  /// In en, this message translates to:
  /// **'Deang'**
  String get ethnicityDeang;

  /// No description provided for @ethnicityBonan.
  ///
  /// In en, this message translates to:
  /// **'Bonan'**
  String get ethnicityBonan;

  /// No description provided for @ethnicityYugur.
  ///
  /// In en, this message translates to:
  /// **'Yugur'**
  String get ethnicityYugur;

  /// No description provided for @ethnicityGin.
  ///
  /// In en, this message translates to:
  /// **'Gin'**
  String get ethnicityGin;

  /// No description provided for @ethnicityTatar.
  ///
  /// In en, this message translates to:
  /// **'Tatar'**
  String get ethnicityTatar;

  /// No description provided for @ethnicityDerung.
  ///
  /// In en, this message translates to:
  /// **'Derung'**
  String get ethnicityDerung;

  /// No description provided for @ethnicityOroqen.
  ///
  /// In en, this message translates to:
  /// **'Oroqen'**
  String get ethnicityOroqen;

  /// No description provided for @ethnicityHezhen.
  ///
  /// In en, this message translates to:
  /// **'Hezhen'**
  String get ethnicityHezhen;

  /// No description provided for @ethnicityMonba.
  ///
  /// In en, this message translates to:
  /// **'Monba'**
  String get ethnicityMonba;

  /// No description provided for @ethnicityLhoba.
  ///
  /// In en, this message translates to:
  /// **'Lhoba'**
  String get ethnicityLhoba;

  /// No description provided for @ethnicityJino.
  ///
  /// In en, this message translates to:
  /// **'Jino'**
  String get ethnicityJino;

  /// No description provided for @ethnicityOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get ethnicityOther;

  /// No description provided for @ethnicityForeignBornChinese.
  ///
  /// In en, this message translates to:
  /// **'Foreign-born Chinese'**
  String get ethnicityForeignBornChinese;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'zh': return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
