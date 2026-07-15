import 'package:calora/app/router/app_routes.dart';
import 'package:calora/core/widgets/calora_action_button.dart';
import 'package:calora/core/widgets/calora_page.dart';
import 'package:calora/features/diary/models/diary_entry.dart';
import 'package:calora/features/diary/models/meal_type.dart';
import 'package:calora/features/diary/providers/diary_provider.dart';
import 'package:calora/features/food/presentation/widgets/custom_food_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomFoodScreen extends StatefulWidget {
  const CustomFoodScreen({super.key});

  @override
  State<CustomFoodScreen> createState() => _CustomFoodScreenState();
}

class _CustomFoodScreenState extends State<CustomFoodScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _servingQuantityController = TextEditingController();
  final _servingUnitController = TextEditingController();
  final _proteinController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatController = TextEditingController();
  final _fiberController = TextEditingController();
  final _sugarController = TextEditingController();
  final _noteController = TextEditingController();
  MealType _meal = MealType.breakfast;
  bool _selectionResolved = false;
  DateTime _loggedAt = DateTime.now();

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _loggedAt,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(
        () => _loggedAt = DateTime(
          date.year,
          date.month,
          date.day,
          _loggedAt.hour,
          _loggedAt.minute,
        ),
      );
    }
  }

  Future<void> _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_loggedAt),
    );
    if (time != null) {
      setState(
        () => _loggedAt = DateTime(
          _loggedAt.year,
          _loggedAt.month,
          _loggedAt.day,
          time.hour,
          time.minute,
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _caloriesController.dispose();
    _servingQuantityController.dispose();
    _servingUnitController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    _fiberController.dispose();
    _sugarController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_selectionResolved) {
      final arguments = ModalRoute.of(context)?.settings.arguments;
      if (arguments is MealSelectionArguments) _meal = arguments.mealType;
      _selectionResolved = true;
    }
    return CaloraPage(
      screenId: 'customfood',
      title: 'Custom food',
      child: ListView(
        children: <Widget>[
          CaloraSection(
            child: CustomFoodForm(
              formKey: _formKey,
              meal: _meal.label,
              onMealChanged: (value) =>
                  setState(() => _meal = MealTypeX.fromStored(value)),
              nameController: _nameController,
              caloriesController: _caloriesController,
              servingQuantityController: _servingQuantityController,
              servingUnitController: _servingUnitController,
              proteinController: _proteinController,
              carbsController: _carbsController,
              fatController: _fatController,
              fiberController: _fiberController,
              sugarController: _sugarController,
              noteController: _noteController,
              loggedAt: _loggedAt,
              onSelectDate: _selectDate,
              onSelectTime: _selectTime,
            ),
          ),
          CaloraSection(
            child: CaloraActionButton(
              label: 'Save to diary',
              onPressed: () async {
                if (!(_formKey.currentState?.validate() ?? false)) return;
                try {
                  await context.read<DiaryProvider>().add(
                    DiaryEntry(
                      id: '',
                      meal: _meal.storedValue,
                      name: _nameController.text.trim(),
                      serving:
                          '${_servingQuantityController.text.trim()} ${_servingUnitController.text.trim()}',
                      calories: int.tryParse(_caloriesController.text) ?? 0,
                      protein: int.tryParse(_proteinController.text) ?? 0,
                      carbs: int.tryParse(_carbsController.text) ?? 0,
                      fat: int.tryParse(_fatController.text) ?? 0,
                      loggedAt: _loggedAt,
                      servingQuantity: _servingQuantityController.text.trim(),
                      servingUnit: _servingUnitController.text.trim(),
                      fiber: int.tryParse(_fiberController.text),
                      sugar: int.tryParse(_sugarController.text),
                      note: _noteController.text.trim(),
                    ),
                  );
                } catch (_) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Could not save diary entry.'),
                      ),
                    );
                  }
                  return;
                }
                if (!context.mounted) return;
                await Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.diary,
                  (route) => route.settings.name == AppRoutes.home,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
