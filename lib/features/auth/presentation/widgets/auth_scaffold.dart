import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:calora/core/widgets/calora_brand_mark.dart';
import 'package:flutter/material.dart';

class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.screenId,
    required this.title,
    required this.subtitle,
    required this.child,
    this.footer,
    this.horizontalPadding = AppSpacing.x4,
    this.titleSize = AppFontSizes.brand,
    this.subtitleSize = AppFontSizes.bodyLarge,
    this.contentSpacing = AppSpacing.x3,
    this.footerSpacing = AppSpacing.x5,
  });

  final String screenId;
  final String title;
  final String subtitle;
  final Widget child;
  final Widget? footer;
  final double horizontalPadding;
  final double titleSize;
  final double subtitleSize;
  final double contentSpacing;
  final double footerSpacing;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: ValueKey<String>(screenId),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: AppSizes.authContentMaxWidth,
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        AppSpacing.x5,
                        horizontalPadding,
                        AppSpacing.x6,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          const Align(
                            alignment: Alignment.center,
                            child: CaloraBrandMark(
                              size: AppSizes.authBrandMark,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sectionGap),
                          Text(
                            title,
                            textAlign: TextAlign.center,
                            style: context.textTheme.headlineLarge?.copyWith(
                              fontSize: titleSize,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            subtitle,
                            textAlign: TextAlign.center,
                            style: context.textTheme.bodyLarge?.copyWith(
                              fontSize: subtitleSize,
                              color: context.colors.inkSoft,
                            ),
                          ),
                          SizedBox(height: contentSpacing),
                          child,
                          if (footer != null) ...<Widget>[
                            SizedBox(height: footerSpacing),
                            footer!,
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
