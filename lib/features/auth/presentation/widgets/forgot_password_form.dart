import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/widgets/calora_action_button.dart';
import 'package:calora/features/auth/presentation/auth_validators.dart';
import 'package:calora/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:flutter/material.dart';

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({
    super.key,
    required this.onSendResetLink,
    required this.onBackToLogin,
    required this.isLoading,
    this.errorMessage,
  });

  final Future<void> Function(String email) onSendResetLink;
  final VoidCallback onBackToLogin;
  final bool isLoading;
  final String? errorMessage;

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await widget.onSendResetLink(_emailController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          AuthTextField(
            label: 'Email',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            autofillHints: const <String>[AutofillHints.email],
            validator: AuthValidators.email,
            onFieldSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: AppSpacing.md),
          if (widget.errorMessage case final message?) ...<Widget>[
            Text(
              message,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          CaloraActionButton(
            label: 'Send Reset Link',
            onPressed: _submit,
            isLoading: widget.isLoading,
          ),
          const SizedBox(height: AppSpacing.sm),
          CaloraActionButton(
            label: 'Back to Log In',
            style: CaloraActionButtonStyle.secondary,
            onPressed: widget.isLoading ? null : widget.onBackToLogin,
          ),
        ],
      ),
    );
  }
}
