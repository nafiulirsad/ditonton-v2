import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie/movie.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/widget_test_helper.dart';

void main() {
  setUp(setUpWidgetTest);

  testWidgets('should display the movie title and overview', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: MovieCard(testMovie))),
    );

    expect(find.text(testMovie.title!), findsOneWidget);
    expect(find.text(testMovie.overview!), findsOneWidget);
  });

  testWidgets('should display a placeholder when the data is empty', (
    WidgetTester tester,
  ) async {
    const movie = Movie.watchlist(
      id: 1,
      title: null,
      posterPath: null,
      overview: null,
    );

    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: MovieCard(movie))),
    );

    expect(find.text('-'), findsNWidgets(2));
  });

  testWidgets('should navigate to the detail page when tapped', (
    WidgetTester tester,
  ) async {
    var routeName = '';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: MovieCard(testMovie)),
        onGenerateRoute: (settings) {
          routeName = settings.name ?? '';
          return MaterialPageRoute<void>(
            builder: (_) => const Scaffold(body: Text('detail')),
          );
        },
      ),
    );

    await tester.tap(find.byKey(Key('movie_card_${testMovie.id}')));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(routeName, MovieDetailPage.routeName);
  });
}
