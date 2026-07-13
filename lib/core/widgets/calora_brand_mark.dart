import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:flutter/material.dart';

class CaloraBrandMark extends StatelessWidget {
  const CaloraBrandMark({super.key, this.size = AppSizes.brandMark});

  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _BrandMarkPainter(context.colors.moss),
    );
  }
}

class _BrandMarkPainter extends CustomPainter {
  const _BrandMarkPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 24;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = AppStrokes.selected * scale
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final leaf = Path()
      ..moveTo(12 * scale, 21 * scale)
      ..cubicTo(
        7.6 * scale,
        21 * scale,
        5 * scale,
        17.8 * scale,
        5 * scale,
        13.6 * scale,
      )
      ..cubicTo(
        5 * scale,
        8.6 * scale,
        9.2 * scale,
        4.6 * scale,
        12 * scale,
        3 * scale,
      )
      ..cubicTo(
        14.8 * scale,
        4.6 * scale,
        19 * scale,
        8.6 * scale,
        19 * scale,
        13.6 * scale,
      )
      ..cubicTo(
        19 * scale,
        17.8 * scale,
        16.4 * scale,
        21 * scale,
        12 * scale,
        21 * scale,
      );
    canvas
      ..drawPath(leaf, paint)
      ..drawLine(
        Offset(12 * scale, 21 * scale),
        Offset(12 * scale, 14 * scale),
        paint,
      );
    final vein = Path()
      ..moveTo(12 * scale, 12 * scale)
      ..cubicTo(
        12 * scale,
        9 * scale,
        14 * scale,
        7 * scale,
        16 * scale,
        6 * scale,
      );
    canvas.drawPath(vein, paint);
  }

  @override
  bool shouldRepaint(covariant _BrandMarkPainter oldDelegate) =>
      oldDelegate.color != color;
}
