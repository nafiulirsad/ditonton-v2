import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/widget_test_helper.dart';

void main() {
  setUp(setUpWidgetTest);

  test('should expose the TMDB image base url', () {
    expect(baseImageUrl, 'https://image.tmdb.org/t/p/w500');
    expect(kAppLogoAsset, contains('circle-g.png'));
  });

  test('should build the text theme from the Poppins font', () {
    expect(kTextTheme.headlineMedium, kHeading5);
    expect(kTextTheme.headlineSmall, kHeading6);
    expect(kTextTheme.labelMedium, kSubtitle);
    expect(kTextTheme.bodyMedium, kBodyText);
    expect(kHeading5.fontSize, 23);
    expect(kBodyText.fontSize, 13);
  });

  testWidgets('should apply the dark theme of the application', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
          drawerTheme: kDrawerTheme,
        ),
        home: Builder(
          builder: (context) => Scaffold(
            body: Text(
              'Ditonton',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
      ),
    );

    final theme = Theme.of(tester.element(find.text('Ditonton')));
    expect(theme.colorScheme.primary, kMikadoYellow);
    expect(theme.scaffoldBackgroundColor, kRichBlack);
    expect(theme.drawerTheme.backgroundColor, kDrawerTheme.backgroundColor);
    expect(kOxfordBlue, isNotNull);
    expect(kDavysGrey, isNotNull);
    expect(kGrey, isNotNull);
  });
}
