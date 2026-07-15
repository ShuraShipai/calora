import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/widgets/calora_form.dart';
import 'package:calora/features/food/presentation/widgets/custom_food_date_time_fields.dart';
import 'package:flutter/material.dart';

class CustomFoodForm extends StatelessWidget {
  const CustomFoodForm({
    super.key,
    required this.formKey,
    required this.meal,
    required this.onMealChanged,
    required this.nameController,
    required this.caloriesController,
    required this.servingQuantityController,
    required this.servingUnitController,
    required this.proteinController,
    required this.carbsController,
    required this.fatController,
    required this.fiberController,
    required this.sugarController,
    required this.noteController,
    required this.loggedAt,
    required this.onSelectDate,
    required this.onSelectTime,
  });

  final GlobalKey<FormState> formKey;
  final String meal;
  final ValueChanged<String> onMealChanged;
  final TextEditingController nameController;
  final TextEditingController caloriesController;
  final TextEditingController servingQuantityController;
  final TextEditingController servingUnitController;
  final TextEditingController proteinController;
  final TextEditingController carbsController;
  final TextEditingController fatController;
  final TextEditingController fiberController;
  final TextEditingController sugarController;
  final TextEditingController noteController;
  final DateTime loggedAt;
  final VoidCallback onSelectDate;
  final VoidCallback onSelectTime;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: <Widget>[
          CaloraLabeledField(
            label: 'Food name',
            controller: nameController,
            hint: 'e.g. Homemade dal',
            validator: (value) => value == null || value.trim().isEmpty
                ? 'Enter a food name to continue'
                : null,
          ),
          const SizedBox(height: AppSpacing.xxl),
          _fieldRow(
            CaloraLabeledField(
              label: 'Serving quantity',
              controller: servingQuantityController,
              hint: 'e.g. 1',
              keyboardType: TextInputType.number,
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Enter quantity'
                  : null,
            ),
            CaloraLabeledField(
              label: 'Serving unit',
              controller: servingUnitController,
              hint: 'e.g. bowl',
              validator: (value) =>
                  value == null || value.trim().isEmpty ? 'Enter unit' : null,
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          CaloraLabeledField(
            label: 'Calories',
            controller: caloriesController,
            hint: 'kcal',
            keyboardType: TextInputType.number,
            validator: (value) =>
                int.tryParse(value ?? '') == null ? 'Enter calories' : null,
          ),
          const SizedBox(height: AppSpacing.xxl),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: CaloraLabeledField(
                  label: 'Protein (g)',
                  controller: proteinController,
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(width: AppSpacing.lg),
              Expanded(
                child: CaloraLabeledField(
                  label: 'Carbs (g)',
                  controller: carbsController,
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(width: AppSpacing.lg),
              Expanded(
                child: CaloraLabeledField(
                  label: 'Fat (g)',
                  controller: fatController,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),
          _fieldRow(
            CaloraLabeledField(
              label: 'Fiber (g)',
              controller: fiberController,
              keyboardType: TextInputType.number,
            ),
            CaloraLabeledField(
              label: 'Sugar (g)',
              controller: sugarController,
              keyboardType: TextInputType.number,
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          Align(
            alignment: Alignment.centerLeft,
            child: Text('Meal', style: Theme.of(context).textTheme.labelMedium),
          ),
          const SizedBox(height: AppSpacing.sm),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: <Widget>[
                for (final value in const <String>[
                  'Breakfast',
                  'Lunch',
                  'Dinner',
                  'Snack',
                ]) ...<Widget>[
                  CaloraChoiceChip(
                    label: value,
                    selected: meal == value,
                    onTap: () => onMealChanged(value),
                  ),
                  if (value != 'Snack') const SizedBox(width: AppSpacing.md),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          CustomFoodDateTimeFields(
            value: loggedAt,
            onSelectDate: onSelectDate,
            onSelectTime: onSelectTime,
          ),
          const SizedBox(height: AppSpacing.xxl),
          CaloraLabeledField(
            label: 'Note (optional)',
            hint: 'Add a note',
            controller: noteController,
          ),
        ],
      ),
    );
  }

  Widget _fieldRow(Widget first, Widget second) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(child: first),
        const SizedBox(width: AppSpacing.lg),
        Expanded(child: second),
      ],
    );
  }
}
