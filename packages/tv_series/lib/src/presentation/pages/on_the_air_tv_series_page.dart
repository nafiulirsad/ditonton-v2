import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/on_the_air_tv_series_bloc.dart';
import '../bloc/tv_series_list_state.dart';
import '../widgets/tv_series_card_list.dart';

class OnTheAirTvSeriesPage extends StatefulWidget {
  static const routeName = AppRoutes.onTheAirTvSeries;

  const OnTheAirTvSeriesPage({super.key});

  @override
  State<OnTheAirTvSeriesPage> createState() => _OnTheAirTvSeriesPageState();
}

class _OnTheAirTvSeriesPageState extends State<OnTheAirTvSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<OnTheAirTvSeriesBloc>().add(const FetchOnTheAirTvSeries());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('On The Air TV Series')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<OnTheAirTvSeriesBloc, TvSeriesListState>(
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
