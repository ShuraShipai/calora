import 'package:flutter/material.dart';

@immutable
class AppShadows extends ThemeExtension<AppShadows> {
  const AppShadows({
    required this.small,
    required this.medium,
    required this.large,
    required this.primaryButton,
    required this.navigationAction,
    required this.sheet,
    required this.toast,
    required this.switchThumb,
  });

  static const light = AppShadows(
    small: <BoxShadow>[
      BoxShadow(color: Color(0x0F1F2A24), offset: Offset(0, 1), blurRadius: 2),
    ],
    medium: <BoxShadow>[
      BoxShadow(color: Color(0x121F2A24), offset: Offset(0, 4), blurRadius: 16),
    ],
    large: <BoxShadow>[
      BoxShadow(
        color: Color(0x241F2A24),
        offset: Offset(0, 12),
        blurRadius: 32,
      ),
    ],
    primaryButton: <BoxShadow>[
      BoxShadow(color: Color(0x403F6B52), offset: Offset(0, 4), blurRadius: 14),
    ],
    navigationAction: <BoxShadow>[
      BoxShadow(color: Color(0x593F6B52), offset: Offset(0, 8), blurRadius: 18),
    ],
    sheet: <BoxShadow>[
      BoxShadow(
        color: Color(0x33000000),
        offset: Offset(0, -8),
        blurRadius: 30,
      ),
    ],
    toast: <BoxShadow>[
      BoxShadow(color: Color(0x40000000), offset: Offset(0, 8), blurRadius: 24),
    ],
    switchThumb: <BoxShadow>[
      BoxShadow(color: Color(0x40000000), offset: Offset(0, 1), blurRadius: 3),
    ],
  );

  static const dark = AppShadows(
    small: <BoxShadow>[
      BoxShadow(color: Color(0x4D000000), offset: Offset(0, 1), blurRadius: 2),
    ],
    medium: <BoxShadow>[
      BoxShadow(color: Color(0x59000000), offset: Offset(0, 6), blurRadius: 20),
    ],
    large: <BoxShadow>[
      BoxShadow(
        color: Color(0x73000000),
        offset: Offset(0, 16),
        blurRadius: 40,
      ),
    ],
    primaryButton: <BoxShadow>[
      BoxShadow(color: Color(0x66000000), offset: Offset(0, 4), blurRadius: 14),
    ],
    navigationAction: <BoxShadow>[
      BoxShadow(color: Color(0x593F6B52), offset: Offset(0, 8), blurRadius: 18),
    ],
    sheet: <BoxShadow>[
      BoxShadow(
        color: Color(0x33000000),
        offset: Offset(0, -8),
        blurRadius: 30,
      ),
    ],
    toast: <BoxShadow>[
      BoxShadow(color: Color(0x40000000), offset: Offset(0, 8), blurRadius: 24),
    ],
    switchThumb: <BoxShadow>[
      BoxShadow(color: Color(0x40000000), offset: Offset(0, 1), blurRadius: 3),
    ],
  );

  final List<BoxShadow> small;
  final List<BoxShadow> medium;
  final List<BoxShadow> large;
  final List<BoxShadow> primaryButton;
  final List<BoxShadow> navigationAction;
  final List<BoxShadow> sheet;
  final List<BoxShadow> toast;
  final List<BoxShadow> switchThumb;

  @override
  AppShadows copyWith({
    List<BoxShadow>? small,
    List<BoxShadow>? medium,
    List<BoxShadow>? large,
    List<BoxShadow>? primaryButton,
    List<BoxShadow>? navigationAction,
    List<BoxShadow>? sheet,
    List<BoxShadow>? toast,
    List<BoxShadow>? switchThumb,
  }) {
    return AppShadows(
      small: small ?? this.small,
      medium: medium ?? this.medium,
      large: large ?? this.large,
      primaryButton: primaryButton ?? this.primaryButton,
      navigationAction: navigationAction ?? this.navigationAction,
      sheet: sheet ?? this.sheet,
      toast: toast ?? this.toast,
      switchThumb: switchThumb ?? this.switchThumb,
    );
  }

  @override
  AppShadows lerp(covariant AppShadows? other, double t) {
    if (other == null) return this;
    return AppShadows(
      small: BoxShadow.lerpList(small, other.small, t)!,
      medium: BoxShadow.lerpList(medium, other.medium, t)!,
      large: BoxShadow.lerpList(large, other.large, t)!,
      primaryButton: BoxShadow.lerpList(primaryButton, other.primaryButton, t)!,
      navigationAction: BoxShadow.lerpList(
        navigationAction,
        other.navigationAction,
        t,
      )!,
      sheet: BoxShadow.lerpList(sheet, other.sheet, t)!,
      toast: BoxShadow.lerpList(toast, other.toast, t)!,
      switchThumb: BoxShadow.lerpList(switchThumb, other.switchThumb, t)!,
    );
  }
}
