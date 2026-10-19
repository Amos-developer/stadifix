import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stadifix_web/features/service_discovery/presentation/screens/provider_list_screen.dart';

void main() {
  testWidgets('Provider list searches, saves, and filters providers', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: ProviderListScreen(category: 'Plumbing')),
    );
    expect(find.text('3 professionals in Nairobi'), findsOneWidget);
    await tester.tap(find.byTooltip('Save James Mwangi'));
    await tester.tap(find.text('Saved'));
    await tester.pumpAndSettle();
    expect(find.text('1 professional in Nairobi'), findsOneWidget);
    expect(find.text('James Mwangi'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'nobody');
    await tester.pumpAndSettle();
    expect(find.text('No professionals found'), findsOneWidget);
    await tester.tap(find.text('Clear filters'));
    await tester.pumpAndSettle();
    expect(find.text('3 professionals in Nairobi'), findsOneWidget);
    await tester.tap(find.byTooltip('Sort and filter'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Price: low to high'));
    await tester.pumpAndSettle();
    final names = tester
        .widgetList<Text>(find.byType(Text))
        .map((text) => text.data)
        .toList();
    expect(
      names.indexOf('Peter Otieno'),
      lessThan(names.indexOf('James Mwangi')),
    );
  });
}
