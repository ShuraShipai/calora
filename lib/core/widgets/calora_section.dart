import 'package:calora/core/theme/app_tokens.dart';
import 'package:flutter/material.dart';

class CaloraSection extends StatelessWidget {
  const CaloraSection({
    super.key,
    required this.child,
    this.bottom = AppSpacing.section,
    this.top = 0,
  });

  final Widget child;
  final double bottom;
  final double top;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.page,
        top,
        AppSpacing.page,
        bottom,
      ),
      child: child,
    );
  }
}
