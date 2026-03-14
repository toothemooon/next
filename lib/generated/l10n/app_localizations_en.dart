// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Tomato';

  @override
  String get phaseFocus => 'Focus';

  @override
  String get phaseShortBreak => 'Short Break';

  @override
  String get phaseLongBreak => 'Long Break';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get notificationTitle => 'Focus Ended';

  @override
  String get notificationBodyFocus => 'You finished a pomodoro!';

  @override
  String get notificationBodyBreak => 'Break is over, time to focus.';

  @override
  String get todayTasks => '// Today\'s Tasks';

  @override
  String get inputTask => 'Enter task...';

  @override
  String get addTask => '+ Add Task...';

  @override
  String get navTimer => 'Timer';

  @override
  String get navStats => 'Stats';

  @override
  String get navSettings => 'Settings';

  @override
  String get finishedBtn => 'Done!';

  @override
  String completedTomatoes(Object count) {
    return 'Completed $count tomatoes';
  }

  @override
  String get startFocus => 'Start Focus';

  @override
  String get pause => 'Pause';

  @override
  String get abandon => 'Interrupt / Abandon';

  @override
  String get settingsTimer => '// Timer';

  @override
  String get focusDuration => 'Focus Duration';

  @override
  String get shortBreak => 'Short Break';

  @override
  String get longBreak => 'Long Break';

  @override
  String get longBreakInterval => 'Long Break Interval';

  @override
  String get settingsOther => '// Other Settings';

  @override
  String get autoNext => 'Auto Start Next Phase';

  @override
  String get vibration => 'Vibration';

  @override
  String get lockTask => 'Lock Task';

  @override
  String get notificationPermission => 'Notifications';

  @override
  String get settingsTheme => '// Theme';

  @override
  String get statsWeeklyTrend => '// Weekly Trend';

  @override
  String statsComboProgress(Object target) {
    return '// $target Combo Progress';
  }

  @override
  String statsUntilLongBreak(Object current, Object target) {
    return '$current / $target until long break';
  }

  @override
  String get statsTimeDistribution => '// Time Distribution';

  @override
  String get statsDetails => '// Details';

  @override
  String get statsTotalCompleted => 'Total Completed';

  @override
  String get statsTotalMinutes => 'Total Minutes';

  @override
  String get statsAverageEfficiency => 'Avg. Efficiency';

  @override
  String statsCountUnit(Object count) {
    return '$count items';
  }

  @override
  String statsMinuteUnit(Object count) {
    return '$count mins';
  }

  @override
  String statsPeriodUnit(Object count) {
    return '$count / 5 periods';
  }

  @override
  String get mon => 'Mon';

  @override
  String get tue => 'Tue';

  @override
  String get wed => 'Wed';

  @override
  String get thu => 'Thu';

  @override
  String get fri => 'Fri';

  @override
  String get sat => 'Sat';

  @override
  String get sun => 'Sun';

  @override
  String get language => 'Language';

  @override
  String get langEnglish => 'English';

  @override
  String get langChinese => 'Chinese';

  @override
  String get langJapanese => 'Japanese';
}
