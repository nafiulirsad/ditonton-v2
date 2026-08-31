import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/tv_series_list_state.dart';
import '../bloc/watchlist_tv_series_bloc.dart';
import '../widgets/tv_series_card_list.dart';

/// Daftar serial TV yang tersimpan pada watchlist.
///
/// Halaman ini ditampilkan sebagai salah satu tab pada halaman watchlist.
class WatchlistTvSeriesPage extends StatefulWidget {
  const WatchlistTvSeriesPage({super.key});

  @override
  State<WatchlistTvSeriesPage> createState() => _WatchlistTvSeriesPageState();
}

class _WatchlistTvSeriesPageState extends State<WatchlistTvSeriesPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<WatchlistTvSeriesBloc>().add(const FetchWatchlistTvSeries());
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
    context.read<WatchlistTvSeriesBloc>().add(const FetchWatchlistTvSeries());
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
      child: BlocBuilder<WatchlistTvSeriesBloc, TvSeriesListState>(
        builder: (context, state) {
          return switch (state) {
            TvSeriesListLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            TvSeriesListHasData(:final result) when result.isEmpty =>
              const Center(
                key: Key('empty_message'),
                child: Text('Belum ada serial TV pada watchlist.'),
              ),
            TvSeriesListHasData(:final result) => ListView.builder(
              itemBuilder: (context, index) => TvSeriesCard(result[index]),
              itemCount: result.length,
            ),
            TvSeriesListError(:final message) => Center(
              key: const Key('error_message'),
              child: Text(message),
            ),
            TvSeriesListEmpty() => const SizedBox.shrink(),
          };
        },
      ),
    );
  }
}
