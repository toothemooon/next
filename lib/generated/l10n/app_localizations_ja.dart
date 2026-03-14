// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Tomato';

  @override
  String get phaseFocus => '集中';

  @override
  String get phaseShortBreak => '短い休憩';

  @override
  String get phaseLongBreak => '長い休憩';

  @override
  String get themeSystem => 'システム設定';

  @override
  String get themeLight => 'ライトモード';

  @override
  String get themeDark => 'ダークモード';

  @override
  String get notificationTitle => '集中終了';

  @override
  String get notificationBodyFocus => 'ポモドーロを完了しました！';

  @override
  String get notificationBodyBreak => '休憩が終了しました。集中を始めましょう。';

  @override
  String get todayTasks => '// 今日のタスク';

  @override
  String get inputTask => 'タスクを入力...';

  @override
  String get addTask => '+ タスクを追加...';

  @override
  String get navTimer => 'タイマー';

  @override
  String get navStats => '統計';

  @override
  String get navSettings => '設定';

  @override
  String get finishedBtn => '完了！';

  @override
  String completedTomatoes(Object count) {
    return '$count 個のポモドーロを完了';
  }

  @override
  String get startFocus => '集中を開始';

  @override
  String get pause => '一時停止';

  @override
  String get abandon => '中断 / 破棄';

  @override
  String get settingsTimer => '// タイマー設定';

  @override
  String get focusDuration => '集中時間';

  @override
  String get shortBreak => '短い休憩';

  @override
  String get longBreak => '長い休憩';

  @override
  String get longBreakInterval => '長い休憩の間隔';

  @override
  String get settingsOther => '// その其他の設定';

  @override
  String get autoNext => '自動で次のフェーズへ';

  @override
  String get vibration => 'バイブレーション';

  @override
  String get lockTask => 'タスクを固定';

  @override
  String get notificationPermission => '通知権限';

  @override
  String get settingsTheme => '// テーマ';

  @override
  String get statsWeeklyTrend => '// 今週のトレンド';

  @override
  String statsComboProgress(Object target) {
    return '// $target コンボ進行状況';
  }

  @override
  String statsUntilLongBreak(Object current, Object target) {
    return '長い休憩まであと $current / $target';
  }

  @override
  String get statsTimeDistribution => '// 時間帯の分布';

  @override
  String get statsDetails => '// 詳細';

  @override
  String get statsTotalCompleted => '合計ポモドーロ数';

  @override
  String get statsTotalMinutes => '合計集中時間';

  @override
  String get statsAverageEfficiency => '平均効率';

  @override
  String statsCountUnit(Object count) {
    return '$count 個';
  }

  @override
  String statsMinuteUnit(Object count) {
    return '$count 分';
  }

  @override
  String statsPeriodUnit(Object count) {
    return '$count / 5 時間帯';
  }

  @override
  String get mon => '月';

  @override
  String get tue => '火';

  @override
  String get wed => '水';

  @override
  String get thu => '木';

  @override
  String get fri => '金';

  @override
  String get sat => '土';

  @override
  String get sun => '日';

  @override
  String get language => '言語';

  @override
  String get langEnglish => '英語';

  @override
  String get langChinese => '中国語';

  @override
  String get langJapanese => '日本語';
}
