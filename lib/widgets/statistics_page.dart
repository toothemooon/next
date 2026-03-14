import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../constants.dart';
import 'pixel_tomato.dart';

// 统计页面：展示番茄钟的关键统计信息与可视化（卡片、柱状图、今日番茄、时间段分布、明细）
// 结构说明：页面被拆分为若干私有构建方法 (`_build...`)：每个方法负责一块 UI，便于阅读和维护。
// 注：图表使用 `fl_chart` 渲染，数据当前为示例静态值；把注释分散在相关方法附近以便快速理解。
// ========== 统计页 Widget ==========
class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

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
                      _buildStatsCards(state),
                      const SizedBox(height: 24),
                      _buildChartSection(state),
                      const SizedBox(height: 24),
                      _buildTomatoSection(state),
                      const SizedBox(height: 24),
                      _buildTimeSlots(state),
                      const SizedBox(height: 24),
                      _buildDetailedStats(state),
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

  // 顶部Header
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 44, 16, 16),
      child: Row(
        children: [
          // 标题显示为“// 统计”，使用等宽字体样式与设置页保持统一视觉风格
          Text('// 统计', style: AppTextStyles.sectionLabel),
          const Spacer(),
          _buildPeriodSelector(),
        ],
      ),
    );
  }

  // 三个统计卡片
  Widget _buildStatsCards(PomodoroState state) {
    return Container(
      decoration: _buildDashedBorder(),
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // 左中右三列分别展示不同的关键指标（数值、单位、变动标识）
          _buildStatItem('${state.todayCompletedCount}', '完成', '', true),
          _buildVerticalDivider(),
          _buildStatItem('${state.totalFocusMinutes}', '分钟', '', true),
          _buildVerticalDivider(),
          _buildStatItem('${state.totalCompleted}', '总番茄数', '', true),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, String change, bool isPositive) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        if (change.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: isPositive ? AppColors.accent.withOpacity(0.5) : AppColors.tomRed.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            // 变动标签：根据是否为正向增长选择不同背景与文字颜色
            child: Text(
              change,
              style: TextStyle(
                fontSize: 10,
                color: isPositive ? AppColors.leaf : AppColors.tomRed,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(height: 40, width: 1, color: AppColors.pixelGrid);
  }

  // 图表区域
  Widget _buildChartSection(PomodoroState state) {
    final weeklyData = state.weeklyCounts;
    final double maxCount = weeklyData.isEmpty ? 8 : (weeklyData.reduce(max) + 2).toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 本周趋势：柱状图展示一周每天的番茄计数
        Text('// 本周趋势', style: _getCodeStyle()),
        const SizedBox(height: 12),
        Container(
          height: 160,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: maxCount,
              barTouchData: const BarTouchData(enabled: false),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) => Text(
                      value.toInt().toString(),
                      style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
                    ),
                    reservedSize: 28,
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    // 底部横轴标签：把索引映射为中文星期
                    getTitlesWidget: (value, meta) {
                      String text;
                      switch (value.toInt()) {
                        case 0: text = '一'; break;
                        case 1: text = '二'; break;
                        case 2: text = '三'; break;
                        case 3: text = '四'; break;
                        case 4: text = '五'; break;
                        case 5: text = '六'; break;
                        case 6: text = '日'; break;
                        default: text = '';
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          text,
                          style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
                        ),
                      );
                    },
                  ),
                ),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              barGroups: List.generate(7, (i) {
                final isToday = DateTime.now().weekday - 1 == i;
                return BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: weeklyData[i].toDouble(),
                      color: isToday ? AppColors.accent : AppColors.accentL,
                      width: 16,
                    )
                  ],
                );
              }),
            ),
          ),
        ),
      ],
    );
  }

  // 番茄区域
  Widget _buildTomatoSection(PomodoroState state) {
    int target = state.longBreakInterval;
    int current = state.completed;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _buildDashedBorder(),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 今日番茄：用多个 `PixelTomato` 表示今日已完成/目标状态
                Text('// $target连击进度', style: _getCodeStyle()),
                const SizedBox(height: 12),
                Row(
                  children: List.generate(
                    target,
                    (index) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: PixelTomato(
                        filled: index < current,
                        size: 32,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text('$current / $target 距离长休息', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.accent,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Colors.white),
          ),
        ],
      ),
    );
  }

  // 时间段选择
  Widget _buildTimeSlots(PomodoroState state) {
    final dist = state.timeSlotDistribution;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 时间段分布：展示一天内按时段的专注次数，颜色表示是否为活跃时段
        Text('// 时间段分布', style: _getCodeStyle()),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildTimeSlot(dist['5-9'].toString(), '5-9', dist['5-9']! > 0),
            _buildTimeSlot(dist['9-12'].toString(), '9-12', dist['9-12']! > 0),
            _buildTimeSlot(dist['12-18'].toString(), '12-18', dist['12-18']! > 0),
            _buildTimeSlot(dist['18-21'].toString(), '18-21', dist['18-21']! > 0),
            _buildTimeSlot(dist['21-24'].toString(), '21-24', dist['21-24']! > 0),
          ],
        ),
      ],
    );
  }

  Widget _buildTimeSlot(String count, String time, bool isActive) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? AppColors.accent : AppColors.accent.withOpacity(0.3),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          children: [
            // 时间段数量（大号字体）
            Text(count, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 4),
            // 时间范围（小字体）
            Text(time, style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.9))),
          ],
        ),
      ),
    );
  }

  // 详细统计
  Widget _buildDetailedStats(PomodoroState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _buildDashedBorder(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 详情区：列出若干关键统计项的标签与数值
          Text('// 详情', style: _getCodeStyle()),
          const SizedBox(height: 12),
          _buildStatRow('总专注番茄数', '${state.totalCompleted} 个'),
          const SizedBox(height: 8),
          _buildStatRow('总计专注时长', '${state.totalFocusMinutes} 分钟'),
          const SizedBox(height: 8),
          _buildStatRow('平均时段效率', '${state.timeSlotDistribution.values.where((v) => v > 0).length} / 5 时段'),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 左侧为统计项标签，右侧为对应的值
        Text(label, style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
        Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
      ],
    );
  }

  // 辅助方法
  BoxDecoration _buildDashedBorder() {
    return BoxDecoration(
      border: Border.all(color: AppColors.accent.withOpacity(0.3), width: 1),
      borderRadius: BorderRadius.circular(8),
    );
  }

  TextStyle _getCodeStyle() {
    return TextStyle(fontSize: 14, color: AppColors.textSecondary, fontFamily: 'monospace');
  }

  Widget _buildPeriodSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Text('周', style: TextStyle(color: Colors.white, fontSize: 12)),
    );
  }
}