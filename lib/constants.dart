import 'package:flutter/material.dart';

/// 全局应用常量配置
/// 包含主题颜色、文字样式等设计系统资源
/// 所有页面和组件都应使用此文件中的常量，保持UI风格一致

// ════════════════════════════════════════
// 🎨 主题颜色
// ════════════════════════════════════════
class AppColors {
  // 背景色系列
  static const Color bg        = Color(0xFFF2EFE2); /// 主背景色
  static const Color bg2       = Color(0xFFE8E4D4); /// 次级背景色
  static const Color pixelGrid = Color(0xFFDEDACA); /// 像素网格/分隔线色
  static const Color card      = Color(0xFFECE8DA); /// 卡片容器背景色
  static const Color navBg     = Color(0xFFEAE6D8); /// 底部导航栏背景色
  static const Color track     = Color(0xFFD8D4C4); /// 进度条/轨道色

  // 文字色系列
  static const Color textPrimary   = Color(0xFF2A2822); /// 主要文字色
  static const Color textSecondary = Color(0xFF9A927E); /// 次要/辅助文字色

  // 主题强调色（绿色系）
  static const Color accent    = Color(0xFF7A9E78); /// 强调色（主绿）
  static const Color accentD   = Color(0xFF567A54); /// 强调色（深绿）
  static const Color accentL   = Color(0xFFA8C4A6); /// 强调色（浅绿）

  // 番茄红色系（代表完成/专注）
  static const Color tomRed    = Color(0xFFC84A32); /// 番茄红（主色）
  static const Color tomRedL   = Color(0xFFE07258); /// 番茄红（浅/高光）
  static const Color tomRedD   = Color(0xFF96301E); /// 番茄红（深/阴影）

  // 番茄空状态色（代表待完成）
  static const Color tomEmpty  = Color(0xFFD8D2C0); /// 空番茄色
  static const Color tomEmptyD = Color(0xFFB8B2A0); /// 空番茄色（深/轮廓）

  // 叶子绿色系
  static const Color leaf      = Color(0xFF568A54); /// 叶子绿（主色）
  static const Color leafD     = Color(0xFF3A6238); /// 叶子绿（深）
  static const Color leafEmpty = Color(0xFFC0C8B8); /// 叶子绿（空状态）

  // 次要强调色
  static const Color secondary = Color(0xFFB87858); /// 次要强调色（棕色系）
}

// ════════════════════════════════════════
// ✍️ 文字样式
// ════════════════════════════════════════
class AppTextStyles {
  // 计时器数字样式
  static const TextStyle time = TextStyle(
    fontFamily: 'Courier',
    fontSize: 64,
    fontWeight: FontWeight.bold,
    letterSpacing: -2,
    color: AppColors.textPrimary,
  );

  // 计时器数字（小号）
  static const TextStyle timeSmall = TextStyle(
    fontFamily: 'Courier',
    fontSize: 48,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  // 标签样式
  static const TextStyle label = TextStyle(
    fontSize: 12,
    letterSpacing: 1.5,
    color: AppColors.textSecondary,
  );

  // 强调标签样式
  static const TextStyle labelAccent = TextStyle(
    fontSize: 14,
    letterSpacing: 2,
    color: AppColors.accent,
    fontWeight: FontWeight.w500,
  );

  // 标签页（激活）
  static const TextStyle tabActive = TextStyle(
    fontSize: 13,
    color: Colors.white,
    fontWeight: FontWeight.w600,
  );

  // 标签页（未激活）
  static const TextStyle tabInactive = TextStyle(
    fontSize: 13,
    color: AppColors.textSecondary,
  );

  // 主按钮文字
  static const TextStyle btnPrimary = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    letterSpacing: 0.5,
  );

  // 次要按钮文字
  static const TextStyle btnSecondary = TextStyle(
    fontSize: 14,
    color: AppColors.secondary,
    fontWeight: FontWeight.w500,
  );

  // 任务列表项
  static const TextStyle taskItem = TextStyle(
    fontSize: 14,
    color: AppColors.textPrimary,
  );

  // 任务列表项（已完成）
  static const TextStyle taskDone = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
    decoration: TextDecoration.lineThrough,
  );

  // 区块标签（像素风格）
  static const TextStyle sectionLabel = TextStyle(
    fontSize: 11,
    color: AppColors.accentD,
    fontFamily: 'Courier',
    letterSpacing: 0.5,
  );

  // 计数文字（像素风格）
  static const TextStyle count = TextStyle(
    fontFamily: 'Courier',
    fontSize: 13,
    color: AppColors.textSecondary,
  );
}