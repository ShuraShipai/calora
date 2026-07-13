abstract final class AuthValidators {
  static String? requiredName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Enter your name.';
    return null;
  }

  static String? email(String? value) {
    final input = value?.trim() ?? '';
    if (input.isEmpty) return 'Enter your email.';
    final parts = input.split('@');
    if (parts.length != 2 || parts.first.isEmpty || !parts.last.contains('.')) {
      return 'Enter a valid email address.';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Enter your password.';
    if (value.length < 6) return 'Use at least 6 characters.';
    return null;
  }
}
