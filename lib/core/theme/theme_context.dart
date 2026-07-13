import 'package:calora/core/theme/app_colors.dart';
import 'package:calora/core/theme/app_shadows.dart';
import 'package:flutter/material.dart';

extension CaloraThemeContext on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  AppColors get colors => theme.extension<AppColors>()!;
  AppShadows get shadows => theme.extension<AppShadows>()!;
}
