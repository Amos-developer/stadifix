import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stadifix_web/features/authentication/data/repositories/auth_repository.dart';
import 'package:stadifix_web/features/authentication/domain/models/register_request.dart';
import 'package:stadifix_web/features/authentication/presentation/screens/register_screen.dart';

class FakeAuthRepository extends AuthRepository {
  RegisterRequest? submitted;

  @override
  Future<void> register(RegisterRequest request) async {
    submitted = request;
  }
}

void main() {
  test('Registration payload matches the API contract', () {
    const request = RegisterRequest(
      fullName: ' Jane Doe ',
      email: ' Jane@Example.com ',
      password: 'a secure password',
      role: UserRole.customer,
    );
    expect(request.toJson(), {
      'fullName': 'Jane Doe',
      'email': 'jane@example.com',
      'password': 'a secure password',
      'role': 'CUSTOMER',
    });
    expect(RegisterRequest.validatePassword('short'), isNotNull);
    expect(
      RegisterRequest.validatePassword(List.filled(37, 'é').join()),
      isNotNull,
    );
    expect(
      RegisterRequest.validatePassword(List.filled(36, 'é').join()),
      isNull,
    );
  });

  testWidgets('Registration validates then submits the API fields', (
    tester,
  ) async {
    final repository = FakeAuthRepository();
    await tester.pumpWidget(
      MaterialApp(home: RegisterScreen(repository: repository)),
    );
    await tester.ensureVisible(find.text('Sign Up'));
    await tester.tap(find.text('Sign Up'));
    await tester.pumpAndSettle();
    expect(repository.submitted, isNull);
    expect(
      find.text('Enter a name between 2 and 120 characters.'),
      findsOneWidget,
    );
    await tester.enterText(find.byType(TextFormField).at(0), 'Jane Doe');
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'jane@example.com',
    );
    await tester.enterText(
      find.byType(TextFormField).at(2),
      'a secure password',
    );
    await tester.ensureVisible(find.byType(Checkbox));
    await tester.tap(find.byType(Checkbox));
    await tester.ensureVisible(find.text('Sign Up'));
    await tester.tap(find.text('Sign Up'));
    await tester.pumpAndSettle();
    expect(repository.submitted?.role, UserRole.customer);
    expect(
      find.text('Your account is ready. Sign in to continue.'),
      findsOneWidget,
    );
  });
}
