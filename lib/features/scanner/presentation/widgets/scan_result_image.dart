import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:flutter/material.dart';

class ScanResultImage extends StatelessWidget {
  const ScanResultImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.scanResultImage,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            context.colors.scanImageStart,
            context.colors.scanImageEnd,
          ],
        ),
        borderRadius: AppRadii.cardBorder,
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.photo_outlined,
        size: AppFontSizes.displayLarge,
        color: context.colors.scanImageInk,
      ),
    );
  }
}
