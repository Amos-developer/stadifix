import 'dart:convert';

enum UserRole {
  customer('CUSTOMER', 'Customer'),
  provider('PROVIDER', 'Service provider');

  const UserRole(this.apiValue, this.label);
  final String apiValue;
  final String label;
}

class RegisterRequest {
  const RegisterRequest({
    required this.fullName,
    required this.email,
    required this.password,
    required this.role,
  });

  final String fullName;
  final String email;
  final String password;
  final UserRole role;

  Map<String, String> toJson() => {
    'fullName': fullName.trim(),
    'email': email.trim().toLowerCase(),
    'password': password,
    'role': role.apiValue,
  };

  static String? validateName(String? value) {
    final name = value?.trim() ?? '';
    if (name.length < 2 || name.length > 120) {
      return 'Enter a name between 2 and 120 characters.';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.length > 254 ||
        !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
      return 'Enter a valid email address.';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    final password = value ?? '';
    if (password.trim().isEmpty ||
        password.length < 12 ||
        password.length > 72) {
      return 'Use between 12 and 72 characters.';
    }
    if (utf8.encode(password).length > 72) {
      return 'Password must not exceed 72 UTF-8 bytes.';
    }
    return null;
  }
}
