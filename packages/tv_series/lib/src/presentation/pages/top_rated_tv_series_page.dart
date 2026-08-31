import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/top_rated_tv_series_bloc.dart';
import '../bloc/tv_series_list_state.dart';
import '../widgets/tv_series_card_list.dart';

class TopRatedTvSeriesPage extends StatefulWidget {
  static const routeName = AppRoutes.topRatedTvSeries;

  const TopRatedTvSeriesPage({super.key});

  @override
  State<TopRatedTvSeriesPage> createState() => _TopRatedTvSeriesPageState();
}

class _TopRatedTvSeriesPageState extends State<TopRatedTvSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<TopRatedTvSeriesBloc>().add(const FetchTopRatedTvSeries());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Top Rated TV Series')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TopRatedTvSeriesBloc, TvSeriesListState>(
          builder: (context, state) {
            return switch (state) {
              TvSeriesListLoading() => const Center(
                child: CircularProgressIndicator(),
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
      ),
    );
  }
}
