import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/main.dart';

void main() {
  testWidgets('App builds and shows loading or home', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MyApp(),
      ),
    );
    await tester.pump();
    final hasLoading = find.byType(CircularProgressIndicator).evaluate().isNotEmpty;
    final hasTitle = find.text('Ibarra Abastecida').evaluate().isNotEmpty;
    expect(hasLoading || hasTitle, isTrue);
  });
}
