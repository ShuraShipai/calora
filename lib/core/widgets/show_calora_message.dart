import 'package:calora/core/theme/app_tokens.dart';
import 'package:flutter/material.dart';

void showCaloraMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(content: Text(message), duration: AppDurations.toast),
    );
}
