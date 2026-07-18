import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/widgets/calora_top_bar.dart';
import 'package:flutter/material.dart';

class CaloraPage extends StatelessWidget {
  const CaloraPage({
    super.key,
    required this.screenId,
    required this.child,
    this.title,
    this.bottomNavigationBar,
    this.backgroundColor,
  });

  final String screenId;
  final Widget child;
  final String? title;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: ValueKey<String>(screenId),
      backgroundColor: backgroundColor,
      bottomNavigationBar: bottomNavigationBar,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppSizes.authContentMaxWidth,
            ),
            child: Column(
              children: <Widget>[
                if (title != null) CaloraTopBar(title: title!),
                Expanded(child: child),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
