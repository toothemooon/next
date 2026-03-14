import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tomato_app/generated/l10n/app_localizations.dart';
import '../main.dart';
import '../constants.dart';
import 'pixel_tomato.dart';

// 设置页面 Widget
// 说明：该文件把设置页拆成多个私有构建方法（_build...），每个方法负责界面中一小块。
// 交互点（按钮、开关）的回调目前为占位（空函数），实际逻辑应由上层状态或 Provider/Bloc 注入。

// ========== 设置页 Widget ==========
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Consumer<PomodoroState>(
      builder: (context, state, child) {
        return Container(
          color: AppColors.bg, // 背景颜色
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTimerSettings(context, state),
                      const SizedBox(height: 24),
                      _buildToggleSettings(context, state),
                      const SizedBox(height: 24),
                      _buildLanguageSelector(context, state),
                      const SizedBox(height: 24),
                      _buildThemeSelector(context, state),
                      const SizedBox(height: 24),
                      _buildVersionInfo(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // 构建顶部标题
  Widget _buildHeader(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 44, 16, 16),
      child: Row(
        children: [
          // 顶部代码风格标题
          Text('// ${l10n.navSettings}', style: AppTextStyles.sectionLabel),
        ],
      ),
    );
  }

  // 构建计时器设置（含长休息间隔）
  Widget _buildTimerSettings(BuildContext context, PomodoroState state) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.settingsTimer, style: AppTextStyles.sectionLabel),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              _buildCounterRow(
                l10n.focusDuration, 
                state.focusDuration, 
                (v) => state.updateFocusDuration(v)
              ),
              Divider(height: 1, color: AppColors.pixelGrid),
              _buildCounterRow(
                l10n.shortBreak, 
                state.shortBreakDuration,
                (v) => state.updateShortBreakDuration(v)
              ),
              Divider(height: 1, color: AppColors.pixelGrid),
              _buildCounterRow(
                l10n.longBreak, 
                state.longBreakDuration,
                (v) => state.updateLongBreakDuration(v)
              ),
              Divider(height: 1, color: AppColors.pixelGrid),
              _buildCounterRow(
                l10n.longBreakInterval,
                state.longBreakInterval,
                (v) => state.updateLongBreakInterval(v),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 构建计数器行（如专注时长）
  Widget _buildCounterRow(String label, int value, ValueChanged<int> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(child: Text(label, style: TextStyle(fontSize: 14, color: AppColors.textPrimary))),
          Row(
            children: [
              _buildCounterButton('-', () => onChanged(value - 1)),
              Container(
                width: 50, // 增加固定宽度以确保水平对齐
                margin: const EdgeInsets.symmetric(horizontal: 8),
                padding: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.bg,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Text('$value', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                ),
              ),
              _buildCounterButton('+', () => onChanged(value + 1)),
            ],
          ),
        ],
      ),
    );
  }

  // 构建计数器按钮
  Widget _buildCounterButton(String text, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AppColors.accent.withOpacity(0.2),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: AppColors.accent),
        ),
        child: Center(
          child: Text(text, style: TextStyle(fontSize: 18, color: AppColors.textPrimary)),
        ),
      ),
    );
  }

  // 构建开关行
  Widget _buildSwitchRow(String label, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(child: Text(label, style: TextStyle(fontSize: 14, color: AppColors.textPrimary))),
          Transform.scale(
            scale: 0.8,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeThumbColor: AppColors.accent,
              activeTrackColor: AppColors.accent.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }

  // 构建其他设置
  Widget _buildToggleSettings(BuildContext context, PomodoroState state) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.settingsOther, style: AppTextStyles.sectionLabel),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              _buildSwitchRow(l10n.autoNext, state.autoStartNext, state.toggleAutoStartNext),
              Divider(height: 1, color: AppColors.pixelGrid),
              _buildSwitchRow(l10n.vibration, state.vibrationEnabled, state.toggleVibration),
              Divider(height: 1, color: AppColors.pixelGrid),
              _buildSwitchRow(l10n.lockTask, state.lockTask, state.toggleLockTask),
              Divider(height: 1, color: AppColors.pixelGrid),
              _buildSwitchRow(l10n.notificationPermission, state.notificationPermissionGranted, (val) => state.requestNotificationPermission()),
            ],
          ),
        ),
      ],
    );

  }

  // 构建语言选择
  Widget _buildLanguageSelector(BuildContext context, PomodoroState state) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('// ${l10n.language}', style: AppTextStyles.sectionLabel),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: _buildDashedBorder(),
          child: Column(
            children: [
              Row(
                children: [
                  _buildLangOption(context, l10n.themeSystem, null, state.locale == null, (loc) => state.setLocale(loc)),
                  const SizedBox(width: 8),
                  _buildLangOption(context, l10n.langEnglish, const Locale('en'), state.locale?.languageCode == 'en', (loc) => state.setLocale(loc)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildLangOption(context, l10n.langChinese, const Locale('zh'), state.locale?.languageCode == 'zh', (loc) => state.setLocale(loc)),
                  const SizedBox(width: 8),
                  _buildLangOption(context, l10n.langJapanese, const Locale('ja'), state.locale?.languageCode == 'ja', (loc) => state.setLocale(loc)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLangOption(BuildContext context, String label, Locale? locale, bool isSelected, Function(Locale?) onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(locale),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.accent : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: AppColors.accent),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 构建主题选择
  Widget _buildThemeSelector(BuildContext context, PomodoroState state) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.settingsTheme, style: AppTextStyles.sectionLabel),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: _buildDashedBorder(),
          child: Column(
            children: [
              // 模式切换 (系统/浅色/深色)
              Row(
                children: AppThemeMode.values.map((mode) {
                  final isSelected = state.appThemeMode == mode;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => state.setAppThemeMode(mode),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.accent : Colors.transparent,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: AppColors.accent),
                        ),
                        child: Center(
                          child: Text(
                            mode.label(context),
                            style: TextStyle(
                              fontSize: 12,
                              color: isSelected ? Colors.white : AppColors.textPrimary,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Divider(height: 1, color: AppColors.pixelGrid),
              const SizedBox(height: 16),
              // 色系选择 (绿/蓝/青)
              Row(
                children: [
                  _buildThemeOption(const Color(0xFF6B8E5E), state.themeIndex == 0, () => state.setThemeIndex(0)),
                  const SizedBox(width: 12),
                  _buildThemeOption(const Color(0xFF3E5A7A), state.themeIndex == 1, () => state.setThemeIndex(1)),
                  const SizedBox(width: 12),
                  _buildThemeOption(const Color(0xFF5A9E9F), state.themeIndex == 2, () => state.setThemeIndex(2)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 构建单个主题选项
  Widget _buildThemeOption(Color color, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: isSelected ? AppColors.textPrimary : Colors.transparent,
              width: 2,
            ),
          ),
          child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 20) : null,
        ),
      ),
    );
  }

  // 构建版本信息
  Widget _buildVersionInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _buildDashedBorder(),
      child: Row(
        children: [
          const PixelTomato(filled: true, size: 24),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tomato', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 2),
              Text('Pixel Zen Pomodoro v1.0', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            ],
          ),
          const Spacer(),
          // 这里的 Toggle 按钮已被移除
        ],
      ),
    );
  }

  // 辅助方法：构建虚线边框
  BoxDecoration _buildDashedBorder() {
    return BoxDecoration(
      border: Border.all(color: AppColors.accent.withOpacity(0.3), width: 1),
      borderRadius: BorderRadius.circular(8),
    );
  }
}
