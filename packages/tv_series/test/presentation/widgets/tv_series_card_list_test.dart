import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tv_series/tv_series.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/widget_test_helper.dart';

void main() {
  setUp(setUpWidgetTest);

  testWidgets('should display the tv series name and overview', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: TvSeriesCard(testTvSeries))),
    );

    expect(find.text(testTvSeries.name!), findsOneWidget);
    expect(find.text(testTvSeries.overview!), findsOneWidget);
  });

  testWidgets('should display a placeholder when the data is empty', (
    WidgetTester tester,
  ) async {
    const tvSeries = TvSeries.watchlist(
      id: 1,
      name: null,
      posterPath: null,
      overview: null,
    );

    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: TvSeriesCard(tvSeries))),
    );

    expect(find.text('-'), findsNWidgets(2));
  });

  testWidgets('should navigate to the detail page when tapped', (
    WidgetTester tester,
  ) async {
    var routeName = '';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: TvSeriesCard(testTvSeries)),
        onGenerateRoute: (settings) {
          routeName = settings.name ?? '';
          return MaterialPageRoute<void>(
            builder: (_) => const Scaffold(body: Text('detail')),
          );
        },
      ),
    );

    await tester.tap(find.byKey(Key('tv_series_card_${testTvSeries.id}')));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(routeName, TvSeriesDetailPage.routeName);
  });
}
