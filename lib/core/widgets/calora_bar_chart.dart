import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:flutter/material.dart';

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
