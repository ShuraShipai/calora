import 'package:calora/core/theme/app_tokens.dart';
import 'package:flutter/material.dart';

class CaloraScreenScaffold extends StatelessWidget {
  const CaloraScreenScaffold({
    super.key,
    required this.screenId,
    this.title,
    this.body = const SizedBox.shrink(),
    this.bottomNavigationBar,
    this.showBackButton = false,
  });

  final String screenId;
  final String? title;
  final Widget body;
  final Widget? bottomNavigationBar;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: ValueKey<String>(screenId),
      appBar: title == null
          ? null
          : AppBar(
              automaticallyImplyLeading: false,
              leadingWidth: showBackButton
                  ? AppSizes.iconButton + AppSpacing.page
                  : 0,
              leading: showBackButton
                  ? Padding(
                      padding: const EdgeInsets.only(left: AppSpacing.page),
                      child: IconButton(
                        tooltip: MaterialLocalizations.of(
                          context,
                        ).backButtonTooltip,
                        onPressed: () => Navigator.maybePop(context),
                        icon: const Icon(Icons.chevron_left),
                      ),
                    )
                  : null,
              titleSpacing: showBackButton ? AppSpacing.xl : AppSpacing.page,
              title: Text(title!),
            ),
      body: SafeArea(top: title == null, child: body),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
