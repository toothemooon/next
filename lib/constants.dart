import 'package:flutter/material.dart';

/// 全局应用常量配置
/// 包含主题颜色、文字样式等设计系统资源
/// 所有页面和组件都应使用此文件中的常量，保持UI风格一致

// ════════════════════════════════════════
// 🎨 主题颜色
// ════════════════════════════════════════
class AppColors {
  // 背景色系列
  static Color bg        = const Color(0xFFF2EFE2); /// 主背景色
  static Color bg2       = const Color(0xFFE8E4D4); /// 次级背景色
  static Color pixelGrid = const Color(0xFFDEDACA); /// 像素网格/分隔线色
  static Color card      = const Color(0xFFECE8DA); /// 卡片容器背景色
  static Color navBg     = const Color(0xFFEAE6D8); /// 底部导航栏背景色
  static Color track     = const Color(0xFFD8D4C4); /// 进度条/轨道色

  // 文字色系列
  static Color textPrimary   = const Color(0xFF2A2822); /// 主要文字色
  static Color textSecondary = const Color(0xFF9A927E); /// 次要/辅助文字色

  // 主题强调色
  static Color accent    = const Color(0xFF7A9E78); /// 强调色（主）
  static Color accentD   = const Color(0xFF567A54); /// 强调色（深）
  static Color accentL   = const Color(0xFFA8C4A6); /// 强调色（浅）

  // 番茄红色系（代表完成/专注）
  static Color tomRed    = const Color(0xFFC84A32); /// 番茄红（主色）
  static Color tomRedL   = const Color(0xFFE07258); /// 番茄红（浅/高光）
  static Color tomRedD   = const Color(0xFF96301E); /// 番茄红（深/阴影）

  // 番茄空状态色（代表待完成）
  static Color tomEmpty  = const Color(0xFFD8D2C0); /// 空番茄色
  static Color tomEmptyD = const Color(0xFFB8B2A0); /// 空番茄色（深/轮廓）

  // 叶子绿色系
  static Color leaf      = const Color(0xFF568A54); /// 叶子绿（主色）
  static Color leafD     = const Color(0xFF3A6238); /// 叶子绿（深）
  static Color leafEmpty = const Color(0xFFC0C8B8); /// 叶子绿（空状态）

  // 次要强调色
  static Color secondary = const Color(0xFFB87858); /// 次要强调色（棕色系）

  /// 切换主题色系
  static void setTheme(int index) {
    switch (index) {
      case 1: // 深蓝 (Deep Blue)
        bg            = const Color(0xFFE8EBF2);
        bg2           = const Color(0xFFDDE2ED);
        pixelGrid     = const Color(0xFFD2D8E5);
        card          = const Color(0xFFE2E6EF);
        navBg         = const Color(0xFFDFE4ED);
        track         = const Color(0xFFCED4E0);
        textPrimary   = const Color(0xFF222831);
        textSecondary = const Color(0xFF7E8A9A);
        accent        = const Color(0xFF5A7A9E);
        accentD       = const Color(0xFF3E5A7A);
        accentL       = const Color(0xFF86A2C4);
        secondary     = const Color(0xFF5878B8);
        break;
      case 2: // 青色 (Teal)
        bg            = const Color(0xFFE2EFF2);
        bg2           = const Color(0xFFD4E8E8);
        pixelGrid     = const Color(0xFFCADEDD);
        card          = const Color(0xFFDAECE8);
        navBg         = const Color(0xFFD8EAE6);
        track         = const Color(0xFFC4D8D4);
        textPrimary   = const Color(0xFF222A2A);
        textSecondary = const Color(0xFF7E9A92);
        accent        = const Color(0xFF5A9E9F);
        accentD       = const Color(0xFF3E7A7A);
        accentL       = const Color(0xFF86C4C2);
        secondary     = const Color(0xFF58B8B0);
        break;
      case 0: // 默认绿 (Classic Green)
      default:
        bg            = const Color(0xFFF2EFE2);
        bg2           = const Color(0xFFE8E4D4);
        pixelGrid     = const Color(0xFFDEDACA);
        card          = const Color(0xFFECE8DA);
        navBg         = const Color(0xFFEAE6D8);
        track         = const Color(0xFFD8D4C4);
        textPrimary   = const Color(0xFF2A2822);
        textSecondary = const Color(0xFF9A927E);
        accent        = const Color(0xFF7A9E78);
        accentD       = const Color(0xFF567A54);
        accentL       = const Color(0xFFA8C4A6);
        secondary     = const Color(0xFFB87858);
        break;
    }
  }
}

// ════════════════════════════════════════
// ✍️ 文字样式
// ════════════════════════════════════════
class AppTextStyles {
  // 计时器数字样式
  static TextStyle get time => TextStyle(
    fontFamily: 'Courier',
    fontSize: 64,
    fontWeight: FontWeight.bold,
    letterSpacing: -2,
    color: AppColors.textPrimary,
  );

  // 计时器数字（小号）
  static TextStyle get timeSmall => TextStyle(
    fontFamily: 'Courier',
    fontSize: 48,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  // 标签样式
  static TextStyle get label => TextStyle(
    fontSize: 12,
    letterSpacing: 1.5,
    color: AppColors.textSecondary,
  );

  // 强调标签样式
  static TextStyle get labelAccent => TextStyle(
    fontSize: 14,
    letterSpacing: 2,
    color: AppColors.accent,
    fontWeight: FontWeight.w500,
  );

  // 标签页（激活）
  static TextStyle get tabActive => const TextStyle(
    fontSize: 13,
    color: Colors.white,
    fontWeight: FontWeight.w600,
  );

  // 标签页（未激活）
  static TextStyle get tabInactive => TextStyle(
    fontSize: 13,
    color: AppColors.textSecondary,
  );

  // 主按钮文字
  static TextStyle get btnPrimary => const TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    letterSpacing: 0.5,
  );

  // 次要按钮文字
  static TextStyle get btnSecondary => TextStyle(
    fontSize: 14,
    color: AppColors.secondary,
    fontWeight: FontWeight.w500,
  );

  // 任务列表项
  static TextStyle get taskItem => TextStyle(
    fontSize: 14,
    color: AppColors.textPrimary,
  );

  // 任务列表项（已完成）
  static TextStyle get taskDone => TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
    decoration: TextDecoration.lineThrough,
  );

  // 区块标签（像素风格）
  static TextStyle get sectionLabel => TextStyle(
    fontSize: 11,
    color: AppColors.accentD,
    fontFamily: 'Courier',
    letterSpacing: 0.5,
  );

  // 计数文字（像素风格）
  static TextStyle get count => TextStyle(
    fontFamily: 'Courier',
    fontSize: 13,
    color: AppColors.textSecondary,
  );
}