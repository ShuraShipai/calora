import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/widgets/calora_form.dart';
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
      heightCm: _numberFrom(_heightController.text),
      currentWeightKg: _numberFrom(_currentWeightController.text),
      targetWeightKg: _numberFrom(_targetWeightController.text),
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
                label: 'Height',
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
                label: 'Current weight',
                controller: _currentWeightController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
            ),
            SizedBox(width: AppSpacing.lg),
            Expanded(
              child: CaloraLabeledField(
                label: 'Target weight',
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
    _ageController.text = '${details?.age ?? 0}';
    _heightController.text = '${details?.heightCm ?? 0} cm';
    _currentWeightController.text = '${details?.currentWeightKg ?? 0} kg';
    _targetWeightController.text = '${details?.targetWeightKg ?? 0} kg';
  }

  double? _numberFrom(String value) {
    final normalized = value.trim().replaceFirst(RegExp(r' (cm|kg)$'), '');
    return double.tryParse(normalized);
  }
}
