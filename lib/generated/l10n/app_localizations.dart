import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
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
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale('zh')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Tomato'**
  String get appTitle;

  /// No description provided for @phaseFocus.
  ///
  /// In en, this message translates to:
  /// **'Focus'**
  String get phaseFocus;

  /// No description provided for @phaseShortBreak.
  ///
  /// In en, this message translates to:
  /// **'Short Break'**
  String get phaseShortBreak;

  /// No description provided for @phaseLongBreak.
  ///
  /// In en, this message translates to:
  /// **'Long Break'**
  String get phaseLongBreak;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @notificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Focus Ended'**
  String get notificationTitle;

  /// No description provided for @notificationBodyFocus.
  ///
  /// In en, this message translates to:
  /// **'You finished a pomodoro!'**
  String get notificationBodyFocus;

  /// No description provided for @notificationBodyBreak.
  ///
  /// In en, this message translates to:
  /// **'Break is over, time to focus.'**
  String get notificationBodyBreak;

  /// No description provided for @todayTasks.
  ///
  /// In en, this message translates to:
  /// **'// Today\'s Tasks'**
  String get todayTasks;

  /// No description provided for @inputTask.
  ///
  /// In en, this message translates to:
  /// **'Enter task...'**
  String get inputTask;

  /// No description provided for @addTask.
  ///
  /// In en, this message translates to:
  /// **'+ Add Task...'**
  String get addTask;

  /// No description provided for @navTimer.
  ///
  /// In en, this message translates to:
  /// **'Timer'**
  String get navTimer;

  /// No description provided for @navStats.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get navStats;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @finishedBtn.
  ///
  /// In en, this message translates to:
  /// **'Done!'**
  String get finishedBtn;

  /// No description provided for @completedTomatoes.
  ///
  /// In en, this message translates to:
  /// **'Completed {count} tomatoes'**
  String completedTomatoes(Object count);

  /// No description provided for @startFocus.
  ///
  /// In en, this message translates to:
  /// **'Start Focus'**
  String get startFocus;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @abandon.
  ///
  /// In en, this message translates to:
  /// **'Interrupt / Abandon'**
  String get abandon;

  /// No description provided for @settingsTimer.
  ///
  /// In en, this message translates to:
  /// **'// Timer'**
  String get settingsTimer;

  /// No description provided for @focusDuration.
  ///
  /// In en, this message translates to:
  /// **'Focus Duration'**
  String get focusDuration;

  /// No description provided for @shortBreak.
  ///
  /// In en, this message translates to:
  /// **'Short Break'**
  String get shortBreak;

  /// No description provided for @longBreak.
  ///
  /// In en, this message translates to:
  /// **'Long Break'**
  String get longBreak;

  /// No description provided for @longBreakInterval.
  ///
  /// In en, this message translates to:
  /// **'Long Break Interval'**
  String get longBreakInterval;

  /// No description provided for @settingsOther.
  ///
  /// In en, this message translates to:
  /// **'// Other Settings'**
  String get settingsOther;

  /// No description provided for @autoNext.
  ///
  /// In en, this message translates to:
  /// **'Auto Start Next Phase'**
  String get autoNext;

  /// No description provided for @vibration.
  ///
  /// In en, this message translates to:
  /// **'Vibration'**
  String get vibration;

  /// No description provided for @lockTask.
  ///
  /// In en, this message translates to:
  /// **'Lock Task'**
  String get lockTask;

  /// No description provided for @notificationPermission.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationPermission;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'// Theme'**
  String get settingsTheme;

  /// No description provided for @statsWeeklyTrend.
  ///
  /// In en, this message translates to:
  /// **'// Weekly Trend'**
  String get statsWeeklyTrend;

  /// No description provided for @statsComboProgress.
  ///
  /// In en, this message translates to:
  /// **'// {target} Combo Progress'**
  String statsComboProgress(Object target);

  /// No description provided for @statsUntilLongBreak.
  ///
  /// In en, this message translates to:
  /// **'{current} / {target} until long break'**
  String statsUntilLongBreak(Object current, Object target);

  /// No description provided for @statsTimeDistribution.
  ///
  /// In en, this message translates to:
  /// **'// Time Distribution'**
  String get statsTimeDistribution;

  /// No description provided for @statsDetails.
  ///
  /// In en, this message translates to:
  /// **'// Details'**
  String get statsDetails;

  /// No description provided for @statsTotalCompleted.
  ///
  /// In en, this message translates to:
  /// **'Total Completed'**
  String get statsTotalCompleted;

  /// No description provided for @statsTotalMinutes.
  ///
  /// In en, this message translates to:
  /// **'Total Minutes'**
  String get statsTotalMinutes;

  /// No description provided for @statsAverageEfficiency.
  ///
  /// In en, this message translates to:
  /// **'Avg. Efficiency'**
  String get statsAverageEfficiency;

  /// No description provided for @statsCountUnit.
  ///
  /// In en, this message translates to:
  /// **'{count} items'**
  String statsCountUnit(Object count);

  /// No description provided for @statsMinuteUnit.
  ///
  /// In en, this message translates to:
  /// **'{count} mins'**
  String statsMinuteUnit(Object count);

  /// No description provided for @statsPeriodUnit.
  ///
  /// In en, this message translates to:
  /// **'{count} / 5 periods'**
  String statsPeriodUnit(Object count);

  /// No description provided for @mon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get mon;

  /// No description provided for @tue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get tue;

  /// No description provided for @wed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get wed;

  /// No description provided for @thu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get thu;

  /// No description provided for @fri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get fri;

  /// No description provided for @sat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get sat;

  /// No description provided for @sun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get sun;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @langEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get langEnglish;

  /// No description provided for @langChinese.
  ///
  /// In en, this message translates to:
  /// **'Chinese'**
  String get langChinese;

  /// No description provided for @langJapanese.
  ///
  /// In en, this message translates to:
  /// **'Japanese'**
  String get langJapanese;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
