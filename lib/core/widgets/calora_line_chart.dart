import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:flutter/material.dart';

class CaloraLineChart extends StatelessWidget {
  const CaloraLineChart({
    super.key,
    required this.values,
    this.height = AppSizes.chart,
    this.showLastPoint = false,
  });

  final List<double> values;
  final double height;
  final bool showLastPoint;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: CustomPaint(
        painter: _LinePainter(
          values: values,
          color: context.colors.moss,
          showLastPoint: showLastPoint,
        ),
      ),
    );
  }
}

class _LinePainter extends CustomPainter {
  const _LinePainter({
    required this.values,
    required this.color,
    required this.showLastPoint,
  });

  final List<double> values;
  final Color color;
  final bool showLastPoint;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;
    if (values.length == 1) {
      if (showLastPoint) {
        canvas.drawCircle(
          Offset(size.width / 2, size.height * values.single),
          AppSpacing.xs,
          Paint()..color = color,
        );
      }
      return;
    }
    final path = Path();
    for (var index = 0; index < values.length; index++) {
      final point = Offset(
        size.width * index / (values.length - 1),
        size.height * values[index],
      );
      if (index == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = AppStrokes.scanner
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, paint);
    if (showLastPoint) {
      canvas.drawCircle(
        Offset(size.width, size.height * values.last),
        AppSpacing.xs,
        Paint()..color = color,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _LinePainter oldDelegate) =>
      oldDelegate.values != values || oldDelegate.color != color;
}
