import 'package:flutter/material.dart';

// ========== 设置页 Widget ==========
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F1E8),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTimerSettings(),
                  const SizedBox(height: 24),
                  _buildBreakSettings(),
                  const SizedBox(height: 24),
                  _buildNotificationSettings(),
                  const SizedBox(height: 24),
                  _buildToggleSettings(),
                  const SizedBox(height: 24),
                  _buildThemeSelector(),
                  const SizedBox(height: 24),
                  _buildVersionInfo(),
                ],
              ),
            ),
          ),
          // _buildBottomNav removed to be handled by parent
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 44, 16, 16),
      child: const Row(
        children: [
          Text('// 设置', style: TextStyle(fontSize: 14, color: Color(0xFF718096), fontFamily: 'monospace')),
        ],
      ),
    );
  }

  // 计时器设置
  Widget _buildTimerSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('// 计时器', style: _getCodeStyle()),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              _buildCounterRow('专注时长', 25),
              const Divider(height: 1, color: Color(0xFFE2E8F0)),
              _buildCounterRow('短休息', 5),
              const Divider(height: 1, color: Color(0xFFE2E8F0)),
              _buildCounterRow('长休息', 15),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCounterRow(String label, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 14, color: Color(0xFF2D3748)))),
          Row(
            children: [
              _buildCounterButton('-', () {}),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F1E8),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text('$value', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
              _buildCounterButton('+', () {}),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCounterButton(String text, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: const Color(0xFF9FB8A4).withOpacity(0.3),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: const Color(0xFF9FB8A4)),
        ),
        child: Center(
          child: Text(text, style: const TextStyle(fontSize: 18, color: Color(0xFF2D3748))),
        ),
      ),
    );
  }

  // 休息设置
  Widget _buildBreakSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('// 休息提醒', style: _getCodeStyle()),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xC8D4B2).withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF9FB8A4).withOpacity(0.5)),
          ),
          child: Row(
            children: [
              const Icon(Icons.notifications_active, color: Color(0xFF6B8E5E), size: 20),
              const SizedBox(width: 8),
              const Expanded(child: Text('每完成4个番茄钟后长休息', style: TextStyle(fontSize: 14, color: Color(0xFF2D3748)))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF6B8E5E),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text('8', style: TextStyle(color: Colors.white, fontSize: 12)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 通知设置
  Widget _buildNotificationSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('// 通知', style: _getCodeStyle()),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              _buildSwitchRow('声音提醒', true),
              const Divider(height: 1, color: Color(0xFFE2E8F0)),
              _buildSwitchRow('震动', true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchRow(String label, bool value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 14, color: Color(0xFF2D3748)))),
          Transform.scale(
            scale: 0.8,
            child: Switch(
              value: value,
              onChanged: (val) {},
              activeColor: const Color(0xFF6B8E5E),
              activeTrackColor: const Color(0xFF9FB8A4).withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  // 开关设置
  Widget _buildToggleSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('// 其他设置', style: _getCodeStyle()),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              _buildSwitchRow('自动开始休息', true),
              const Divider(height: 1, color: Color(0xFFE2E8F0)),
              _buildSwitchRow('自动开始专注', true),
              const Divider(height: 1, color: Color(0xFFE2E8F0)),
              _buildSwitchRow('显示通知计数', false),
              const Divider(height: 1, color: Color(0xFFE2E8F0)),
              _buildSwitchRow('锁定任务', true),
            ],
          ),
        ),
      ],
    );
  }

  // 主题选择
  Widget _buildThemeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('// 主题', style: _getCodeStyle()),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: _buildDashedBorder(),
          child: Row(
            children: [
              _buildThemeOption(const Color(0xFF6B8E5E), true),
              const SizedBox(width: 12),
              _buildThemeOption(const Color(0xFF5A6C8E), false),
              const SizedBox(width: 12),
              _buildThemeOption(const Color(0xFF5A8E9F), false),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildThemeOption(Color color, bool isSelected) {
    return Expanded(
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected ? const Color(0xFF2D3748) : Colors.transparent,
            width: 2,
          ),
        ),
        child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 20) : null,
      ),
    );
  }

  // 版本信息
  Widget _buildVersionInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _buildDashedBorder(),
      child: Row(
        children: [
          const Icon(Icons.water_drop, color: Color(0xFFC53030), size: 24),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tomato', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2D3748))),
              SizedBox(height: 2),
              Text('Pixel Zen Pomodoro v1.0', style: TextStyle(fontSize: 12, color: Color(0xFF718096))),
            ],
          ),
          const Spacer(),
          Transform.scale(
            scale: 0.8,
            child: Switch(
              value: false,
              onChanged: (val) {},
              activeColor: const Color(0xFF6B8E5E),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _buildDashedBorder() {
    return BoxDecoration(
      border: Border.all(color: const Color(0xFF9FB8A4).withOpacity(0.3), width: 1),
      borderRadius: BorderRadius.circular(8),
    );
  }

  TextStyle _getCodeStyle() {
    return const TextStyle(fontSize: 14, color: Color(0xFF718096), fontFamily: 'monospace');
  }
}