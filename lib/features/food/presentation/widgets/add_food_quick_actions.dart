import 'dart:async';

import 'package:calora/app/router/app_routes.dart';
import 'package:calora/core/widgets/calora_list.dart';
import 'package:calora/core/widgets/calora_page.dart';
import 'package:calora/features/diary/models/meal_type.dart';
import 'package:calora/features/scanner/models/scanner_request.dart';
import 'package:flutter/material.dart';

class AddFoodQuickActions extends StatelessWidget {
  const AddFoodQuickActions({super.key, required this.arguments});
  final Object? arguments;

  MealType get _mealType => arguments is MealSelectionArguments
      ? (arguments! as MealSelectionArguments).mealType
      : MealType.breakfast;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const CaloraSectionTitle('Quick actions'),
        CaloraGroupedList(
          children: <Widget>[
            CaloraListRow(
              icon: Icons.photo_camera_outlined,
              title: 'Scan food',
              subtitle: 'Point your camera at a meal',
              onTap: () => unawaited(
                Navigator.pushNamed(
                  context,
                  AppRoutes.scanner,
                  arguments: ScannerRequest.meal(mealType: _mealType),
                ),
              ),
            ),
            CaloraListRow(
              icon: Icons.qr_code_scanner,
              title: 'Scan barcode',
              subtitle: 'Packaged foods & products',
              onTap: () => unawaited(
                Navigator.pushNamed(
                  context,
                  AppRoutes.scanner,
                  arguments: ScannerRequest.barcode(mealType: _mealType),
                ),
              ),
            ),
            CaloraListRow(
              icon: Icons.copy_outlined,
              title: 'Copy previous meal',
              subtitle: "Re-log something you've eaten before",
              onTap: () => unawaited(
                Navigator.pushNamed(
                  context,
                  AppRoutes.copyMeal,
                  arguments: MealSelectionArguments(_mealType),
                ),
              ),
            ),
            CaloraListRow(
              icon: Icons.add,
              title: 'Create custom food',
              subtitle: 'Enter your own nutrition values',
              onTap: () => unawaited(
                Navigator.pushNamed(
                  context,
                  AppRoutes.customFood,
                  arguments: arguments,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
