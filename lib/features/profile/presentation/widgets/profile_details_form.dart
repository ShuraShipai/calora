import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/widgets/calora_form.dart';
import 'package:calora/core/formatters/measurement_formatter.dart';
import 'package:calora/core/models/user_profile.dart';
import 'package:flutter/material.dart';

class ProfileDetailsForm extends StatefulWidget {
  const ProfileDetailsForm({super.key, required this.profile});

  final UserProfile? profile;

  @override
  State<ProfileDetailsForm> createState() => ProfileDetailsFormState();
}

class ProfileDetailsFormState extends State<ProfileDetailsForm> {
  late final TextEditingController _nameController;
  late final TextEditingController _ageController;
  late final TextEditingController _heightController;
  late final TextEditingController _currentWeightController;
  late final TextEditingController _targetWeightController;

  OnboardingDetails get details {
    final existing = widget.profile?.onboarding ?? const OnboardingDetails();
    return existing.copyWith(
      age: int.tryParse(_ageController.text.trim()),
      heightCm: _convertedHeight(
        _numberFrom(_heightController.text),
        existing.unitSystem,
      ),
      currentWeightKg: _convertedWeight(
        _numberFrom(_currentWeightController.text),
        existing.unitSystem,
      ),
      targetWeightKg: _convertedWeight(
        _numberFrom(_targetWeightController.text),
        existing.unitSystem,
      ),
    );
  }

  String get name => _nameController.text.trim();

  bool get isValid =>
      name.isNotEmpty &&
      int.tryParse(_ageController.text.trim()) != null &&
      _numberFrom(_heightController.text) != null &&
      _numberFrom(_currentWeightController.text) != null &&
      _numberFrom(_targetWeightController.text) != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _ageController = TextEditingController();
    _heightController = TextEditingController();
    _currentWeightController = TextEditingController();
    _targetWeightController = TextEditingController();
    _seedFromProfile();
  }

  @override
  void didUpdateWidget(covariant ProfileDetailsForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.profile != widget.profile) _seedFromProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _currentWeightController.dispose();
    _targetWeightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final existingUnit = widget.profile?.onboarding?.unitSystem;
    return Column(
      children: <Widget>[
        CaloraLabeledField(label: 'Name', controller: _nameController),
        const SizedBox(height: AppSpacing.xxl),
        Row(
          children: <Widget>[
            Expanded(
              child: CaloraLabeledField(
                label: 'Age',
                controller: _ageController,
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(width: AppSpacing.lg),
            Expanded(
              child: CaloraLabeledField(
                label: existingUnit == UnitSystem.imperial
                    ? 'Height (in)'
                    : 'Height (cm)',
                controller: _heightController,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xxl),
        Row(
          children: <Widget>[
            Expanded(
              child: CaloraLabeledField(
                label: existingUnit == UnitSystem.imperial
                    ? 'Current weight (lb)'
                    : 'Current weight (kg)',
                controller: _currentWeightController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
            ),
            SizedBox(width: AppSpacing.lg),
            Expanded(
              child: CaloraLabeledField(
                label: existingUnit == UnitSystem.imperial
                    ? 'Target weight (lb)'
                    : 'Target weight (kg)',
                controller: _targetWeightController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _seedFromProfile() {
    final details = widget.profile?.onboarding;
    _nameController.text = widget.profile?.name ?? '';
    final unitSystem = details?.unitSystem;
    _ageController.text = details?.age?.toString() ?? '';
    _heightController.text = details?.heightCm == null
        ? ''
        : MeasurementFormatter.heightFromCm(
            details!.heightCm!,
            unitSystem,
          ).toStringAsFixed(1);
    _currentWeightController.text = details?.currentWeightKg == null
        ? ''
        : MeasurementFormatter.weightFromKg(
            details!.currentWeightKg!,
            unitSystem,
          ).toStringAsFixed(1);
    _targetWeightController.text = details?.targetWeightKg == null
        ? ''
        : MeasurementFormatter.weightFromKg(
            details!.targetWeightKg!,
            unitSystem,
          ).toStringAsFixed(1);
  }

  double? _numberFrom(String value) {
    return double.tryParse(value.trim());
  }

  double? _convertedHeight(double? value, UnitSystem? unitSystem) =>
      value == null ? null : MeasurementFormatter.heightToCm(value, unitSystem);

  double? _convertedWeight(double? value, UnitSystem? unitSystem) =>
      value == null ? null : MeasurementFormatter.weightToKg(value, unitSystem);
}
