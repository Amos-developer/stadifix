import 'package:flutter/material.dart';

import '../../data/repositories/auth_repository.dart';
import '../../domain/models/register_request.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    super.key,
    this.repository = const AuthRepository(),
    this.onSignIn,
  });

  final AuthRepository repository;
  final VoidCallback? onSignIn;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  static const _blue = Color(0xFF0075FF);
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  UserRole _role = UserRole.customer;
  bool _obscurePassword = true;
  bool _acceptedTerms = false;
  bool _showTermsError = false;
  bool _submitting = false;
  String? _error;
  bool _registered = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _signIn() {
    if (widget.onSignIn case final callback?) {
      callback();
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
      );
    }
  }

  Future<void> _submit() async {
    if (_submitting) return;
    final valid = _formKey.currentState!.validate();
    setState(() {
      _showTermsError = !_acceptedTerms;
      _error = null;
    });
    if (!valid || !_acceptedTerms) return;
    FocusScope.of(context).unfocus();
    setState(() => _submitting = true);
    try {
      await widget.repository.register(
        RegisterRequest(
          fullName: _name.text,
          email: _email.text,
          password: _password.text,
          role: _role,
        ),
      );
      if (!mounted) return;
      _password.clear();
      setState(() => _registered = true);
    } on RegistrationException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } catch (_) {
      if (mounted) {
        setState(
          () => _error = 'Unable to create your account. Please try again.',
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  InputDecoration _decoration(
    String label,
    String hint,
    IconData icon, {
    Widget? suffix,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      prefixIcon: Icon(icon, size: 21, color: const Color(0xFF4D566C)),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white,
      labelStyle: const TextStyle(color: Color(0xFF252C40), fontSize: 14),
      hintStyle: const TextStyle(color: Color(0xFF9096A4), fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(13)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(color: Color(0xFFE7EAF0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(color: _blue, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFCFF),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(28, 8, 28, 20),
              child: AutofillGroup(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          tooltip: 'Back',
                          onPressed: _submitting
                              ? null
                              : () => Navigator.of(context).maybePop(),
                          icon: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(height: 42),
                      const Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.6,
                          color: Color(0xFF080D20),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Join StadiFix to start booking services.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF73798A),
                        ),
                      ),
                      const SizedBox(height: 28),
                      if (_registered) ...[
                        const Icon(
                          Icons.check_circle_outline,
                          color: _blue,
                          size: 64,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Your account is ready. Sign in to continue.',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        FilledButton(
                          onPressed: _signIn,
                          child: const Text('Sign In'),
                        ),
                      ] else ...[
                        TextFormField(
                          controller: _name,
                          enabled: !_submitting,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.name],
                          validator: RegisterRequest.validateName,
                          decoration: _decoration(
                            'Full Name',
                            'John Doe',
                            Icons.person_outline_rounded,
                          ),
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _email,
                          enabled: !_submitting,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          autocorrect: false,
                          autofillHints: const [AutofillHints.email],
                          validator: RegisterRequest.validateEmail,
                          decoration: _decoration(
                            'Email',
                            'john@example.com',
                            Icons.mail_outline_rounded,
                          ),
                        ),
                        const SizedBox(height: 14),
                        DropdownButtonFormField<UserRole>(
                          initialValue: _role,
                          decoration: _decoration(
                            'Account Type',
                            '',
                            Icons.work_outline_rounded,
                          ),
                          items: UserRole.values
                              .map(
                                (role) => DropdownMenuItem(
                                  value: role,
                                  child: Text(
                                    role.label,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: _submitting
                              ? null
                              : (role) => setState(() => _role = role!),
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _password,
                          enabled: !_submitting,
                          obscureText: _obscurePassword,
                          autocorrect: false,
                          enableSuggestions: false,
                          autofillHints: const [AutofillHints.newPassword],
                          validator: RegisterRequest.validatePassword,
                          onFieldSubmitted: (_) => _submit(),
                          decoration: _decoration(
                            'Password',
                            'At least 12 characters',
                            Icons.lock_outline_rounded,
                            suffix: IconButton(
                              tooltip: _obscurePassword
                                  ? 'Show password'
                                  : 'Hide password',
                              onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            SizedBox(
                              width: 30,
                              child: Checkbox(
                                value: _acceptedTerms,
                                activeColor: _blue,
                                semanticLabel:
                                    'I agree to the Terms and Conditions',
                                onChanged: _submitting
                                    ? null
                                    : (value) => setState(() {
                                        _acceptedTerms = value ?? false;
                                        _showTermsError = !_acceptedTerms;
                                      }),
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              'I agree to the ',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF73798A),
                              ),
                            ),
                            Flexible(
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                ),
                                onPressed: () => showDialog<void>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Terms & Conditions'),
                                    content: const Text(
                                      'The StadiFix terms are not available yet. Please review the published terms before creating an account.',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Close'),
                                      ),
                                    ],
                                  ),
                                ),
                                child: const Text(
                                  'Terms & Conditions',
                                  style: TextStyle(fontSize: 12, color: _blue),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (_showTermsError)
                          const Text(
                            'Please accept the Terms & Conditions.',
                            style: TextStyle(
                              color: Color(0xFFBA1A1A),
                              fontSize: 12,
                            ),
                          ),
                        if (_error != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Semantics(
                              liveRegion: true,
                              child: Text(
                                _error!,
                                style: const TextStyle(
                                  color: Color(0xFFBA1A1A),
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 52,
                          child: FilledButton(
                            onPressed: _submitting ? null : _submit,
                            style: FilledButton.styleFrom(
                              backgroundColor: _blue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _submitting
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      semanticsLabel: 'Creating account',
                                    ),
                                  )
                                : const Text(
                                    'Sign Up',
                                    style: TextStyle(fontSize: 16),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 22),
                        const Text(
                          'Or continue with',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF73798A),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Tooltip(
                              message: 'Google sign-up is not available yet',
                              child: IconButton(
                                onPressed: null,
                                icon: const Text(
                                  'G',
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF9CA3AF),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 24),
                            const Tooltip(
                              message: 'Apple sign-up is not available yet',
                              child: IconButton(
                                onPressed: null,
                                icon: Icon(Icons.apple, size: 28),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Flexible(
                              child: Text(
                                'Already have an account?',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF73798A),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: _submitting ? null : _signIn,
                              child: const Text(
                                'Sign In',
                                style: TextStyle(fontSize: 13, color: _blue),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
