import 'package:core/core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/movie.dart';
import 'package:tv_series/tv_series.dart';

import 'common/app_router.dart';
import 'firebase_options.dart';
import 'injection.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final firebaseReady = await _initializeFirebase();
  await di.init();

  runApp(
    MyApp(
      analyticsObserver: firebaseReady
          // Mencatat setiap perpindahan halaman ke Firebase Analytics.
          ? FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance)
          : null,
    ),
  );
}

/// Menyalakan Firebase beserta pelaporan crash otomatis.
///
/// Mengembalikan `true` bila Firebase siap dipakai. Kegagalan inisialisasi tidak
/// mematikan aplikasi supaya aplikasi tetap dapat dijalankan pada lingkungan
/// yang belum memiliki berkas konfigurasi Firebase.
Future<bool> _initializeFirebase() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    registerCrashHandlers(
      reporter: FirebaseCrashReporter(
        crashlytics: FirebaseCrashlytics.instance,
      ),
    );
    return true;
  } catch (error, stackTrace) {
    debugPrint('Firebase gagal diinisialisasi: $error');
    debugPrintStack(stackTrace: stackTrace);
    return false;
  }
}

class MyApp extends StatelessWidget {
  /// Observer Analytics yang bernilai `null` ketika Firebase tidak tersedia,
  /// misalnya pada pengujian.
  final NavigatorObserver? analyticsObserver;

  const MyApp({super.key, this.analyticsObserver});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.locator<NowPlayingMoviesBloc>()),
        BlocProvider(create: (_) => di.locator<PopularMoviesBloc>()),
        BlocProvider(create: (_) => di.locator<TopRatedMoviesBloc>()),
        BlocProvider(create: (_) => di.locator<MovieDetailBloc>()),
        BlocProvider(create: (_) => di.locator<MovieRecommendationsBloc>()),
        BlocProvider(create: (_) => di.locator<MovieSearchBloc>()),
        BlocProvider(create: (_) => di.locator<WatchlistMoviesBloc>()),
        BlocProvider(create: (_) => di.locator<WatchlistMovieStatusBloc>()),
        BlocProvider(create: (_) => di.locator<OnTheAirTvSeriesBloc>()),
        BlocProvider(create: (_) => di.locator<PopularTvSeriesBloc>()),
        BlocProvider(create: (_) => di.locator<TopRatedTvSeriesBloc>()),
        BlocProvider(create: (_) => di.locator<TvSeriesDetailBloc>()),
        BlocProvider(create: (_) => di.locator<TvSeriesRecommendationsBloc>()),
        BlocProvider(create: (_) => di.locator<TvSeriesSearchBloc>()),
        BlocProvider(create: (_) => di.locator<WatchlistTvSeriesBloc>()),
        BlocProvider(create: (_) => di.locator<WatchlistTvSeriesStatusBloc>()),
        BlocProvider(create: (_) => di.locator<SeasonDetailBloc>()),
      ],
      child: MaterialApp(
        title: 'Ditonton',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
          drawerTheme: kDrawerTheme,
        ),
        home: const HomeMoviePage(),
        navigatorObservers: [routeObserver, ?analyticsObserver],
        onGenerateRoute: generateRoute,
      ),
    );
  }
}
