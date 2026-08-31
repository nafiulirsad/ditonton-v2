import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/movie_list_state.dart';
import '../bloc/watchlist_movies_bloc.dart';
import '../widgets/movie_card_list.dart';

/// Daftar film yang tersimpan pada watchlist.
///
/// Halaman ini ditampilkan sebagai salah satu tab pada halaman watchlist.
class WatchlistMoviesPage extends StatefulWidget {
  const WatchlistMoviesPage({super.key});

  @override
  State<WatchlistMoviesPage> createState() => _WatchlistMoviesPageState();
}

class _WatchlistMoviesPageState extends State<WatchlistMoviesPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<WatchlistMoviesBloc>().add(const FetchWatchlistMovies());
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is ModalRoute<void>) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void didPopNext() {
    context.read<WatchlistMoviesBloc>().add(const FetchWatchlistMovies());
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<WatchlistMoviesBloc, MovieListState>(
        builder: (context, state) {
          return switch (state) {
            MovieListLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            MovieListHasData(:final result) when result.isEmpty => const Center(
              key: Key('empty_message'),
              child: Text('Belum ada film pada watchlist.'),
            ),
            MovieListHasData(:final result) => ListView.builder(
              itemBuilder: (context, index) => MovieCard(result[index]),
              itemCount: result.length,
            ),
            MovieListError(:final message) => Center(
              key: const Key('error_message'),
              child: Text(message),
            ),
            MovieListEmpty() => const SizedBox.shrink(),
          };
        },
      ),
    );
  }
}
