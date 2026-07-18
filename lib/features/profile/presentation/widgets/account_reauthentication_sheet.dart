import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:calora/core/widgets/calora_action_button.dart';
import 'package:calora/core/widgets/calora_sheet.dart';
import 'package:flutter/material.dart';

class AccountReauthenticationSheet extends StatefulWidget {
  const AccountReauthenticationSheet({super.key});

  @override
  State<AccountReauthenticationSheet> createState() =>
      _AccountReauthenticationSheetState();
}

class _AccountReauthenticationSheetState
    extends State<AccountReauthenticationSheet> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => CaloraSheet(
    title: 'Confirm it’s you',
    subtitle: 'Enter your password to permanently delete your account.',
    child: Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Password', style: context.textTheme.labelMedium),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                textInputAction: TextInputAction.done,
                validator: (value) => value == null || value.isEmpty
                    ? 'Enter your password.'
                    : null,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.section),
          CaloraActionButton(
            label: 'Continue',
            onPressed: () {
              if (!(_formKey.currentState?.validate() ?? false)) return;
              Navigator.pop(context, _passwordController.text);
            },
          ),
        ],
      ),
    ),
  );
}
