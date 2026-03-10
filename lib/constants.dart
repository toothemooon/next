import 'package:flutter/material.dart';

// ════════════════════════════════════════
// 🎨 主题颜色
// ════════════════════════════════════════
class AppColors {
  static const Color bg        = Color(0xFFF2EFE2);
  static const Color bg2       = Color(0xFFE8E4D4);
  static const Color pixelGrid = Color(0xFFDEDACA);
  static const Color card      = Color(0xFFECE8DA);
  static const Color navBg     = Color(0xFFEAE6D8);
  static const Color track     = Color(0xFFD8D4C4);

  static const Color textPrimary   = Color(0xFF2A2822);
  static const Color textSecondary = Color(0xFF9A927E);

  static const Color accent    = Color(0xFF7A9E78);
  static const Color accentD   = Color(0xFF567A54);
  static const Color accentL   = Color(0xFFA8C4A6);

  static const Color tomRed    = Color(0xFFC84A32);
  static const Color tomRedL   = Color(0xFFE07258);
  static const Color tomRedD   = Color(0xFF96301E);

  static const Color tomEmpty  = Color(0xFFD8D2C0);
  static const Color tomEmptyD = Color(0xFFB8B2A0);

  static const Color leaf      = Color(0xFF568A54);
  static const Color leafD     = Color(0xFF3A6238);
  static const Color leafEmpty = Color(0xFFC0C8B8);

  static const Color secondary = Color(0xFFB87858);
}

// ════════════════════════════════════════
// ✍️ 文字样式
// ════════════════════════════════════════
class AppTextStyles {
  static const TextStyle time = TextStyle(
    fontFamily: 'Courier',
    fontSize: 64,
    fontWeight: FontWeight.bold,
    letterSpacing: -2,
    color: AppColors.textPrimary,
  );

  static const TextStyle timeSmall = TextStyle(
    fontFamily: 'Courier',
    fontSize: 48,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle label = TextStyle(
    fontSize: 12,
    letterSpacing: 1.5,
    color: AppColors.textSecondary,
  );

  static const TextStyle labelAccent = TextStyle(
    fontSize: 14,
    letterSpacing: 2,
    color: AppColors.accent,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle tabActive = TextStyle(
    fontSize: 13,
    color: Colors.white,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle tabInactive = TextStyle(
    fontSize: 13,
    color: AppColors.textSecondary,
  );

  static const TextStyle btnPrimary = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    letterSpacing: 0.5,
  );

  static const TextStyle btnSecondary = TextStyle(
    fontSize: 14,
    color: AppColors.secondary,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle taskItem = TextStyle(
    fontSize: 14,
    color: AppColors.textPrimary,
  );

  static const TextStyle taskDone = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
    decoration: TextDecoration.lineThrough,
  );

  static const TextStyle sectionLabel = TextStyle(
    fontSize: 11,
    color: AppColors.accentD,
    fontFamily: 'Courier',
    letterSpacing: 0.5,
  );

  static const TextStyle count = TextStyle(
    fontFamily: 'Courier',
    fontSize: 13,
    color: AppColors.textSecondary,
  );
}