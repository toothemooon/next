import 'package:flutter/material.dart';
import '../constants.dart';

// Pixel 风格的番茄图标组件：用于在界面中显示像素化的番茄（可填充或空心）。
// 设计思路：在一个 9 列左右的像素网格上通过绘制小矩形来拼出番茄图案，支持填充与高光、叶子、阴影等状态。

class PixelTomato extends StatelessWidget {
  final bool filled;
  final double size;

  const PixelTomato({super.key, this.filled = false, this.size = 24});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size * 1.2),
      painter: _TomatoPainter(filled: filled),
    );
  }
}

class _TomatoPainter extends CustomPainter {
  final bool filled;
  _TomatoPainter({required this.filled});

  @override
  void paint(Canvas canvas, Size size) {
    final px = size.width / 9;

    // 颜色选择：根据 `filled` 状态使用不同的一组颜色常量，便于表现填充/空心、亮面、叶子和阴影。
    final bodyColor  = filled ? AppColors.tomRed    : AppColors.tomEmpty;
    final hiColor    = filled ? AppColors.tomRedL   : AppColors.bg;
    final leafColor  = filled ? AppColors.leaf      : AppColors.leafEmpty;
    final shadowColor= filled ? AppColors.tomRedD   : AppColors.tomEmptyD;
    final outlineColor= filled ? null : AppColors.tomEmptyD;

    void dot(int gx, int gy, Color c) {
      // 在网格 (gx, gy) 处绘制一个像素方块，使用 `px` 计算实际尺寸。
      final rect = Rect.fromLTWH(
        (gx) * px, (gy) * px,
        px - 0.5, px - 0.5,
      );
      canvas.drawRect(rect, Paint()..color = c);
    }

    // Stem & Leaves
    dot(4, 0, leafColor);
    dot(4, 1, leafColor);
    dot(2,1,leafColor); dot(3,1,leafColor);
    dot(1,2,leafColor); dot(2,2,leafColor);
    dot(5,1,leafColor); dot(6,1,leafColor);
    dot(6,2,leafColor); dot(7,2,leafColor);
    dot(3,2,leafColor); dot(4,2,leafColor); dot(5,2,leafColor);

    // Body：按行绘制番茄主体及其阴影，保留像素化风格的明确行列。
    for (final gx in [2,3,4,5,6]) dot(gx,3,bodyColor);
    dot(1,3,shadowColor); dot(7,3,shadowColor);
    for (int gx=1; gx<=7; gx++) dot(gx,4,bodyColor);
    dot(0,4,shadowColor); dot(8,4,shadowColor);
    for (int gx=0; gx<=8; gx++) dot(gx,5,bodyColor);
    for (int gx=0; gx<=8; gx++) dot(gx,6,bodyColor);
    dot(0,6,shadowColor); dot(8,6,shadowColor);
    for (int gx=1; gx<=7; gx++) dot(gx,7,bodyColor);
    dot(1,7,shadowColor); dot(7,7,shadowColor);
    for (final gx in [2,3,4,5,6]) dot(gx,8,bodyColor);
    dot(2,8,shadowColor); dot(6,8,shadowColor);
    for (final gx in [3,4,5]) dot(gx,9,shadowColor);

    // Highlight
    if (filled) {
      dot(1,4,hiColor); dot(2,4,hiColor);
      dot(1,5,hiColor);
    }

    // Outline for empty：如果是空心状态，额外绘制外轮廓像素以表现边框。
    if (outlineColor != null) {
      dot(1,3,outlineColor); dot(7,3,outlineColor);
      dot(0,4,outlineColor); dot(8,4,outlineColor);
    }
  }

  @override
  bool shouldRepaint(_TomatoPainter old) => old.filled != filled;
}