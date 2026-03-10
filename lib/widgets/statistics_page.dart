import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

// ========== 统计页 Widget ==========
class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F1E8), // 米色背景
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatsCards(),
                  const SizedBox(height: 24),
                  _buildChartSection(),
                  const SizedBox(height: 24),
                  _buildTomatoSection(),
                  const SizedBox(height: 24),
                  _buildTimeSlots(),
                  const SizedBox(height: 24),
                  _buildDetailedStats(),
                ],
              ),
            ),
          ),
          // _buildBottomNav removed to be handled by parent
        ],
      ),
    );
  }

  // 顶部Header
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 44, 16, 16),
      child: Row(
        children: [
          Text('// 统计', style: _getCodeStyle()),
          const Spacer(),
          _buildPeriodSelector(),
        ],
      ),
    );
  }

  // 三个统计卡片
  Widget _buildStatsCards() {
    return Container(
      decoration: _buildDashedBorder(),
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('6', '完成', '+2', true),
          _buildVerticalDivider(),
          _buildStatItem('150', '分钟', '+12%', true),
          _buildVerticalDivider(),
          _buildStatItem('3', '专注', '-1', false),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, String change, bool isPositive) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF2D3748))),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF718096))),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: isPositive ? const Color(0xC8D4B2).withOpacity(0.5) : const Color(0xFFE53E3E).withOpacity(0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            change,
            style: TextStyle(
              fontSize: 10,
              color: isPositive ? const Color(0xFF4A7C59) : const Color(0xFFE53E3E),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(height: 40, width: 1, color: const Color(0xFFE2E8F0));
  }

  // 图表区域
  Widget _buildChartSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              maxY: 8,
              barTouchData: BarTouchData(enabled: false),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) => Text(
                      value.toInt().toString(),
                      style: const TextStyle(fontSize: 10, color: Color(0xFF718096)),
                    ),
                    reservedSize: 28,
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
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
                          style: const TextStyle(fontSize: 10, color: Color(0xFF718096)),
                        ),
                      );
                    },
                  ),
                ),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              barGroups: [
                BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 3, color: const Color(0xFF9FB8A4), width: 16)]),
                BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 5, color: const Color(0xFF9FB8A4), width: 16)]),
                BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 2, color: const Color(0xFF9FB8A4), width: 16)]),
                BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 7, color: const Color(0xFF9FB8A4), width: 16)]),
                BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 4, color: const Color(0xFF9FB8A4), width: 16)]),
                BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 6, color: const Color(0xFF6B8E5E), width: 16)]),
                BarChartGroupData(x: 6, barRods: [BarChartRodData(toY: 1, color: const Color(0xFF9FB8A4), width: 16)]),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // 番茄区域
  Widget _buildTomatoSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _buildDashedBorder(),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('// 今日番茄', style: _getCodeStyle()),
                const SizedBox(height: 12),
                Row(
                  children: List.generate(
                    4,
                    (index) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Icon(
                        Icons.water_drop, // 用滴状图标代替番茄
                        color: index < 3 ? const Color(0xFFC53030) : const Color(0xFFCBD5E0),
                        size: 32,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text('3 / 4 目标', style: TextStyle(fontSize: 12, color: Color(0xFF718096))),
              ],
            ),
          ),
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: Color(0xFF9FB8A4),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Colors.white),
          ),
        ],
      ),
    );
  }

  // 时间段选择
  Widget _buildTimeSlots() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('// 时间段', style: _getCodeStyle()),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildTimeSlot('1', '5-9', false),
            _buildTimeSlot('4', '9-12', true),
            _buildTimeSlot('3', '12-18', true),
            _buildTimeSlot('5', '18-21', true),
            _buildTimeSlot('2', '21-24', false),
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
          color: isActive ? const Color(0xFF6B8E5E) : const Color(0xFF9FB8A4).withOpacity(0.5),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          children: [
            Text(count, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 4),
            Text(time, style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.9))),
          ],
        ),
      ),
    );
  }

  // 详细统计
  Widget _buildDetailedStats() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _buildDashedBorder(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('// 详情', style: _getCodeStyle()),
          const SizedBox(height: 12),
          _buildStatRow('专注次数', '5 次'),
          const SizedBox(height: 8),
          _buildStatRow('总时长', '38 分钟'),
          const SizedBox(height: 8),
          _buildStatRow('平均效率', '15.8 %'),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Color(0xFF718096))),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF2D3748))),
      ],
    );
  }

  // 辅助方法
  BoxDecoration _buildDashedBorder() {
    return BoxDecoration(
      border: Border.all(color: const Color(0xFF9FB8A4).withOpacity(0.3), width: 1),
      borderRadius: BorderRadius.circular(8),
    );
  }

  TextStyle _getCodeStyle() {
    return const TextStyle(fontSize: 14, color: Color(0xFF718096), fontFamily: 'monospace');
  }

  Widget _buildPeriodSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF6B8E5E),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Text('周', style: TextStyle(color: Colors.white, fontSize: 12)),
    );
  }
}