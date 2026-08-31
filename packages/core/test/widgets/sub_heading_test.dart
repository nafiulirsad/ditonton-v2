import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/widget_test_helper.dart';

void main() {
  setUp(setUpWidgetTest);

  testWidgets('should display the title and trigger the callback when tapped', (
    WidgetTester tester,
  ) async {
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SubHeading(title: 'Popular', onTap: () => tapped = true),
        ),
      ),
    );

    expect(find.text('Popular'), findsOneWidget);
    expect(find.text('See More'), findsOneWidget);

    await tester.tap(find.text('See More'));
    await tester.pump();

    expect(tapped, true);
  });
}
