import 'package:calora/core/theme/app_tokens.dart';
import 'package:flutter/material.dart';

class CaloraCard extends StatelessWidget {
  const CaloraCard({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: padding ?? const EdgeInsets.all(AppSpacing.section),
        child: child,
      ),
    );
  }
}
