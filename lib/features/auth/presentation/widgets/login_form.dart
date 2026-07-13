import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/widgets/calora_action_button.dart';
import 'package:calora/features/auth/presentation/auth_validators.dart';
import 'package:calora/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
    required this.onLogIn,
    required this.onForgotPassword,
    required this.isLoading,
    this.errorMessage,
  });

  final Future<void> Function(String email, String password) onLogIn;
  final VoidCallback onForgotPassword;
  final bool isLoading;
  final String? errorMessage;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await widget.onLogIn(_emailController.text, _passwordController.text);
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
            autofillHints: const <String>[AutofillHints.password],
            validator: AuthValidators.password,
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
            label: 'Log In',
            onPressed: _submit,
            isLoading: widget.isLoading,
          ),
          const SizedBox(height: AppSpacing.xxl),
          Align(
            child: TextButton(
              onPressed: widget.isLoading ? null : widget.onForgotPassword,
              child: const Text('Forgot password?'),
            ),
          ),
        ],
      ),
    );
  }
}
