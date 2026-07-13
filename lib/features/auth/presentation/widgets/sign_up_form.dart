import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/widgets/calora_action_button.dart';
import 'package:calora/features/auth/presentation/auth_validators.dart';
import 'package:calora/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:flutter/material.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    super.key,
    required this.onCreateAccount,
    required this.isLoading,
    this.errorMessage,
  });

  final Future<void> Function(String name, String email, String password)
  onCreateAccount;
  final bool isLoading;
  final String? errorMessage;

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await widget.onCreateAccount(
      _nameController.text,
      _emailController.text,
      _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          AuthTextField(
            label: 'Name',
            controller: _nameController,
            textInputAction: TextInputAction.next,
            autofillHints: const <String>[AutofillHints.name],
            validator: AuthValidators.requiredName,
          ),
          const SizedBox(height: AppSpacing.xxl),
          AuthTextField(
            label: 'Email',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autofillHints: const <String>[AutofillHints.email],
            validator: AuthValidators.email,
          ),
          const SizedBox(height: AppSpacing.xxl),
          AuthTextField(
            label: 'Password',
            controller: _passwordController,
            obscureText: true,
            textInputAction: TextInputAction.done,
            autofillHints: const <String>[AutofillHints.newPassword],
            validator: AuthValidators.password,
            onFieldSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: AppSpacing.sm),
          if (widget.errorMessage case final message?) ...<Widget>[
            Text(
              message,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          CaloraActionButton(
            label: 'Create Account',
            onPressed: _submit,
            isLoading: widget.isLoading,
          ),
        ],
      ),
    );
  }
}
