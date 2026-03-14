import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../constants.dart';
import 'pixel_tomato.dart';

// 设置页面 Widget
// 说明：该文件把设置页拆成多个私有构建方法（_build...），每个方法负责界面中一小块。
// 交互点（按钮、开关）的回调目前为占位（空函数），实际逻辑应由上层状态或 Provider/Bloc 注入。
// 注：仅添加注释以帮助理解，未修改控件树或任何回调实现。

// ========== 设置页 Widget ==========
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PomodoroState>(
      builder: (context, state, child) {
        return Container(
          color: AppColors.bg, // 背景颜色
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTimerSettings(state),
                      const SizedBox(height: 24),
                      _buildToggleSettings(state),
                      const SizedBox(height: 24),
                      _buildThemeSelector(state),
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
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 44, 16, 16),
      child: Row(
        children: [
          // 顶部代码风格标题
          Text('// 设置', style: AppTextStyles.sectionLabel),
        ],
      ),
    );
  }

  // 构建计时器设置（含长休息间隔）
  Widget _buildTimerSettings(PomodoroState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('// 计时器', style: AppTextStyles.sectionLabel),
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
                '专注时长', 
                state.focusDuration, 
                (v) => state.updateFocusDuration(v)
              ),
              Divider(height: 1, color: AppColors.pixelGrid),
              _buildCounterRow(
                '短休息', 
                state.shortBreakDuration,
                (v) => state.updateShortBreakDuration(v)
              ),
              Divider(height: 1, color: AppColors.pixelGrid),
              _buildCounterRow(
                '长休息', 
                state.longBreakDuration,
                (v) => state.updateLongBreakDuration(v)
              ),
              Divider(height: 1, color: AppColors.pixelGrid),
              _buildCounterRow(
                '长休息间隔',
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
  Widget _buildToggleSettings(PomodoroState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('// 其他设置', style: AppTextStyles.sectionLabel),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              _buildSwitchRow('自动进入下一阶段', state.autoStartNext, state.toggleAutoStartNext),
              Divider(height: 1, color: AppColors.pixelGrid),
              _buildSwitchRow('震动', state.vibrationEnabled, state.toggleVibration),
              Divider(height: 1, color: AppColors.pixelGrid),
              _buildSwitchRow('锁定任务', state.lockTask, state.toggleLockTask),
            ],
          ),
        ),
      ],
    );

  }

  // 构建主题选择
  Widget _buildThemeSelector(PomodoroState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('// 主题', style: AppTextStyles.sectionLabel),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: _buildDashedBorder(),
          child: Row(
            children: [
              _buildThemeOption(const Color(0xFF6B8E5E), state.themeIndex == 0, () => state.setThemeIndex(0)),
              const SizedBox(width: 12),
              _buildThemeOption(const Color(0xFF3E5A7A), state.themeIndex == 1, () => state.setThemeIndex(1)),
              const SizedBox(width: 12),
              _buildThemeOption(const Color(0xFF5A9E9F), state.themeIndex == 2, () => state.setThemeIndex(2)),
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
          Transform.scale(
            scale: 0.8,
            child: Switch(
              value: false,
              onChanged: (val) {},
              activeThumbColor: AppColors.accent,
            ),
          ),
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