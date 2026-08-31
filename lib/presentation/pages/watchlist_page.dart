import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:movie/movie.dart';
import 'package:tv_series/tv_series.dart';

/// Menampilkan watchlist film dan serial TV dalam dua tab terpisah.
class WatchlistPage extends StatelessWidget {
  static const routeName = AppRoutes.watchlist;

  const WatchlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Watchlist'),
          bottom: const TabBar(
            tabs: [
              Tab(key: Key('watchlist_movie_tab'), text: 'Movies'),
              Tab(key: Key('watchlist_tv_series_tab'), text: 'TV Series'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [WatchlistMoviesPage(), WatchlistTvSeriesPage()],
        ),
      ),
    );
  }
}
