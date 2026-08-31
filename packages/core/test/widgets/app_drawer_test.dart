import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/widget_test_helper.dart';

void main() {
  setUp(setUpWidgetTest);

  Future<String> pumpDrawerAndTap(
    WidgetTester tester, {
    required String currentRoute,
    required Key itemKey,
  }) async {
    var routeName = '';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('Ditonton')),
          drawer: AppDrawer(currentRoute: currentRoute),
          body: const SizedBox.shrink(),
        ),
        onGenerateRoute: (settings) {
          routeName = settings.name ?? '';
          return MaterialPageRoute<void>(
            builder: (_) => const Scaffold(body: Text('page')),
          );
        },
      ),
    );

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    await tester.tap(find.byKey(itemKey));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    return routeName;
  }

  testWidgets('should display every navigation item', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('Ditonton')),
          drawer: const AppDrawer(currentRoute: AppRoutes.homeMovie),
          body: const SizedBox.shrink(),
        ),
      ),
    );

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Movies'), findsOneWidget);
    expect(find.text('TV Series'), findsOneWidget);
    expect(find.text('Watchlist'), findsOneWidget);
    expect(find.text('About'), findsOneWidget);
  });

  testWidgets('should navigate to the tv series page', (tester) async {
    final routeName = await pumpDrawerAndTap(
      tester,
      currentRoute: AppRoutes.homeMovie,
      itemKey: const Key('drawer_tv_series'),
    );

    expect(routeName, AppRoutes.homeTvSeries);
  });

  testWidgets('should navigate to the movie page', (tester) async {
    final routeName = await pumpDrawerAndTap(
      tester,
      currentRoute: AppRoutes.homeTvSeries,
      itemKey: const Key('drawer_movies'),
    );

    expect(routeName, AppRoutes.homeMovie);
  });

  testWidgets('should navigate to the watchlist page', (tester) async {
    final routeName = await pumpDrawerAndTap(
      tester,
      currentRoute: AppRoutes.homeMovie,
      itemKey: const Key('drawer_watchlist'),
    );

    expect(routeName, AppRoutes.watchlist);
  });

  testWidgets('should navigate to the about page', (tester) async {
    final routeName = await pumpDrawerAndTap(
      tester,
      currentRoute: AppRoutes.homeMovie,
      itemKey: const Key('drawer_about'),
    );

    expect(routeName, AppRoutes.about);
  });

  testWidgets('should only close the drawer when the active page is tapped', (
    tester,
  ) async {
    final routeName = await pumpDrawerAndTap(
      tester,
      currentRoute: AppRoutes.homeMovie,
      itemKey: const Key('drawer_movies'),
    );

    expect(routeName, '');
  });
}
