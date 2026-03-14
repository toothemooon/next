// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Tomato';

  @override
  String get phaseFocus => '专注';

  @override
  String get phaseShortBreak => '短休';

  @override
  String get phaseLongBreak => '长休';

  @override
  String get themeSystem => '跟随系统';

  @override
  String get themeLight => '浅色';

  @override
  String get themeDark => '深色';

  @override
  String get notificationTitle => '专注结束';

  @override
  String get notificationBodyFocus => '你完成了一个番茄钟！';

  @override
  String get notificationBodyBreak => '休息结束，该开始专注了。';

  @override
  String get todayTasks => '// 今日任务';

  @override
  String get inputTask => '输入任务...';

  @override
  String get addTask => '+ 添加任务...';

  @override
  String get navTimer => '计时';

  @override
  String get navStats => '统计';

  @override
  String get navSettings => '设置';

  @override
  String get finishedBtn => '完成！';

  @override
  String completedTomatoes(Object count) {
    return '已完成第 $count 个番茄';
  }

  @override
  String get startFocus => '开始专注';

  @override
  String get pause => '暂停';

  @override
  String get abandon => '打断 / 废弃';

  @override
  String get settingsTimer => '// 计时器';

  @override
  String get focusDuration => '专注时长';

  @override
  String get shortBreak => '短休息';

  @override
  String get longBreak => '长休息';

  @override
  String get longBreakInterval => '长休息间隔';

  @override
  String get settingsOther => '// 其他设置';

  @override
  String get autoNext => '自动进入下一阶段';

  @override
  String get vibration => '震动';

  @override
  String get lockTask => '锁定任务';

  @override
  String get notificationPermission => '通知权限';

  @override
  String get settingsTheme => '// 主题';

  @override
  String get statsWeeklyTrend => '// 本周趋势';

  @override
  String statsComboProgress(Object target) {
    return '// $target 连击进度';
  }

  @override
  String statsUntilLongBreak(Object current, Object target) {
    return '$current / $target 距离长休息';
  }

  @override
  String get statsTimeDistribution => '// 时间段分布';

  @override
  String get statsDetails => '// 详情';

  @override
  String get statsTotalCompleted => '总专注番茄数';

  @override
  String get statsTotalMinutes => '总计专注时长';

  @override
  String get statsAverageEfficiency => '平均时段效率';

  @override
  String statsCountUnit(Object count) {
    return '$count 个';
  }

  @override
  String statsMinuteUnit(Object count) {
    return '$count 分钟';
  }

  @override
  String statsPeriodUnit(Object count) {
    return '$count / 5 时段';
  }

  @override
  String get mon => '一';

  @override
  String get tue => '二';

  @override
  String get wed => '三';

  @override
  String get thu => '四';

  @override
  String get fri => '五';

  @override
  String get sat => '六';

  @override
  String get sun => '日';

  @override
  String get language => '语言';

  @override
  String get langEnglish => '英文';

  @override
  String get langChinese => '中文';

  @override
  String get langJapanese => '日文';
}
