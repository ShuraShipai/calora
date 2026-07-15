import 'dart:math' as math;

import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:flutter/material.dart';

class CaloraStatPill extends StatelessWidget {
  const CaloraStatPill({super.key, required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: context.colors.surfaceAlt,
        borderRadius: BorderRadius.circular(AppRadii.input),
      ),
      child: Column(
        children: <Widget>[
          Text(
            value,
            maxLines: 1,
            style: context.textTheme.titleMedium?.copyWith(
              fontSize: AppFontSizes.stat,
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            label,
            maxLines: 1,
            style: context.textTheme.labelSmall?.copyWith(
              color: context.colors.inkSoft,
            ),
          ),
        ],
      ),
    );
  }
}

class CaloraMacroMeter extends StatelessWidget {
  const CaloraMacroMeter({
    super.key,
    required this.label,
    required this.value,
    required this.filled,
    required this.color,
  });

  final String label;
  final String value;
  final int filled;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(label, style: context.textTheme.labelMedium),
            Text(
              value,
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colors.inkSoft,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: List<Widget>.generate(
            8,
            (index) => Expanded(
              child: Container(
                height: AppSpacing.xxl,
                margin: EdgeInsets.only(right: index == 7 ? 0 : AppSpacing.xxs),
                decoration: BoxDecoration(
                  color: index < filled ? color : context.colors.surfaceAlt,
                  borderRadius: BorderRadius.circular(AppRadii.grain),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CaloraProgressRing extends StatelessWidget {
  const CaloraProgressRing({
    super.key,
    required this.value,
    required this.primaryText,
    required this.secondaryText,
    this.size = AppSizes.calorieRing,
    this.stroke = AppSpacing.xxl,
    this.color,
  });

  final double value;
  final String primaryText;
  final String secondaryText;
  final double size;
  final double stroke;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          CustomPaint(
            size: Size.square(size),
            painter: _RingPainter(
              value: value,
              stroke: stroke,
              trackColor: context.colors.surfaceAlt,
              progressColor: color ?? context.colors.moss,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(primaryText, style: context.textTheme.headlineMedium),
              Text(
                secondaryText,
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colors.inkSoft,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CaloraBarChart extends StatelessWidget {
  const CaloraBarChart({
    super.key,
    required this.values,
    this.labels = const <String>['M', 'T', 'W', 'T', 'F', 'S', 'S'],
    this.highlighted = const <int>{3, 6},
    this.color,
    this.height = AppSizes.chart,
  });

  final List<double> values;
  final List<String> labels;
  final Set<int> highlighted;
  final Color? color;
  final double height;

  @override
  Widget build(BuildContext context) {
    final baseColor = color ?? context.colors.moss;
    return SizedBox(
      height: height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List<Widget>.generate(values.length, (index) {
          return Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Flexible(
                  child: FractionallySizedBox(
                    heightFactor: values[index],
                    child: Container(
                      width: AppSpacing.xl,
                      decoration: BoxDecoration(
                        color: baseColor.withValues(
                          alpha: highlighted.contains(index) ? 1 : 0.58,
                        ),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(AppRadii.xs),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(labels[index], style: context.textTheme.labelSmall),
              ],
            ),
          );
        }),
      ),
    );
  }
}

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

class _RingPainter extends CustomPainter {
  const _RingPainter({
    required this.value,
    required this.stroke,
    required this.trackColor,
    required this.progressColor,
  });

  final double value;
  final double stroke;
  final Color trackColor;
  final Color progressColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - stroke - (AppSizes.ringInset * 2)) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final track = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;
    final progress = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas
      ..drawCircle(center, radius, track)
      ..drawArc(
        rect,
        -math.pi / 2,
        math.pi * 2 * value.clamp(0, 1),
        false,
        progress,
      );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      oldDelegate.value != value ||
      oldDelegate.trackColor != trackColor ||
      oldDelegate.progressColor != progressColor;
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
