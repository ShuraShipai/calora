import 'package:flutter/material.dart';

abstract final class AppSpacing {
  static const xxs = 3.0;
  static const xs = 4.0;
  static const sm = 6.0;
  static const md = 8.0;
  static const lg = 10.0;
  static const xl = 12.0;
  static const input = 13.0;
  static const xxl = 14.0;
  static const section = 16.0;
  static const sectionGap = 18.0;
  static const page = 20.0;
  static const loose = 22.0;
  static const x3 = 24.0;
  static const sheet = 26.0;
  static const x4 = 28.0;
  static const x5 = 30.0;
  static const x6 = 34.0;
  static const x7 = 40.0;
  static const x8 = 44.0;
  static const x9 = 52.0;
  static const x10 = 56.0;
  static const x11 = 64.0;
  static const x12 = 76.0;
  static const x13 = 80.0;
}

abstract final class AppRadii {
  static const grain = 3.0;
  static const xs = 4.0;
  static const tight = 6.0;
  static const sm = 8.0;
  static const input = 10.0;
  static const thumbnail = 11.0;
  static const compact = 14.0;
  static const medium = 16.0;
  static const button = 18.0;
  static const large = 24.0;
  static const sheet = 26.0;
  static const scanner = 28.0;
  static const deviceScreen = 38.0;
  static const device = 52.0;
  static const handle = 99.0;
  static const full = 999.0;

  static const inputBorder = BorderRadius.all(Radius.circular(input));
  static const cardBorder = BorderRadius.all(Radius.circular(medium));
  static const largeBorder = BorderRadius.all(Radius.circular(large));
  static const pillBorder = BorderRadius.all(Radius.circular(full));
}

abstract final class AppFontSizes {
  static const nav = 10.5;
  static const caption = 11.0;
  static const detail = 11.5;
  static const label = 12.0;
  static const sectionLabel = 12.5;
  static const bodySmall = 13.0;
  static const body = 13.5;
  static const bodyLarge = 14.0;
  static const control = 14.5;
  static const input = 15.0;
  static const stat = 16.0;
  static const compactTitle = 16.5;
  static const sheetTitle = 17.0;
  static const pageTitle = 19.0;
  static const sectionTitle = 20.0;
  static const onboardingTitle = 21.0;
  static const titleLarge = 24.0;
  static const display = 26.0;
  static const brand = 27.0;
  static const hero = 30.0;
  static const displayLarge = 34.0;
}

abstract final class AppFontWeights {
  static const regular = FontWeight.w400;
  static const medium = FontWeight.w500;
  static const semiBold = FontWeight.w600;
  static const bold = FontWeight.w700;
}

abstract final class AppElevations {
  static const none = 0.0;
  static const low = 1.0;
  static const medium = 4.0;
  static const high = 12.0;
}

abstract final class AppDurations {
  static const fast = Duration(milliseconds: 150);
  static const standard = Duration(milliseconds: 250);
  static const spinner = Duration(milliseconds: 900);
  static const scannerAnalysis = Duration(milliseconds: 1600);
  static const toast = Duration(milliseconds: 2200);
}

abstract final class AppSizes {
  static const iconSmall = 14.0;
  static const icon = 20.0;
  static const navigationIcon = 22.0;
  static const iconButton = 36.0;
  static const switchWidth = 42.0;
  static const switchHeight = 24.0;
  static const navigationAction = 52.0;
  static const captureButton = 70.0;
  static const brandMark = 64.0;
  static const authBrandMark = 54.0;
  static const actionButtonHeight = 46.0;
  static const authContentMaxWidth = 430.0;
  static const onboardingIcon = 38.0;
  static const splashProgressWidth = 120.0;
  static const progressHeight = 4.0;
  static const listIcon = 34.0;
  static const foodThumbnail = 42.0;
  static const addButton = 30.0;
  static const profileAvatar = 56.0;
  static const calorieRing = 164.0;
  static const waterRing = 150.0;
  static const chart = 100.0;
  static const compactChart = 70.0;
  static const scanResultImage = 150.0;
  static const scannerAction = 44.0;
  static const scannerControl = 42.0;
  static const ringInset = 5.0;
  static const spinner = 38.0;
  static const sheetHandleWidth = 42.0;
  static const sheetHandleHeight = 4.0;
}

abstract final class AppRatios {
  static const scannerFrameWidth = 0.78;
}

abstract final class AppStrokes {
  static const thin = 1.0;
  static const selected = 1.5;
  static const icon = 1.7;
  static const scanner = 2.0;
  static const spinner = 3.0;
}

abstract final class AppOpacity {
  static const disabled = 0.45;
  static const scrim = 0.42;
  static const scannerControl = 0.14;
  static const splashProgress = 0.60;
}
