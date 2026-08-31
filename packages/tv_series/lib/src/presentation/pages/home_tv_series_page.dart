import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/tv_series.dart';
import '../bloc/on_the_air_tv_series_bloc.dart';
import '../bloc/popular_tv_series_bloc.dart';
import '../bloc/top_rated_tv_series_bloc.dart';
import '../bloc/tv_series_list_state.dart';

class HomeTvSeriesPage extends StatefulWidget {
  static const routeName = AppRoutes.homeTvSeries;

  const HomeTvSeriesPage({super.key});

  @override
  State<HomeTvSeriesPage> createState() => _HomeTvSeriesPageState();
}

class _HomeTvSeriesPageState extends State<HomeTvSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<OnTheAirTvSeriesBloc>().add(const FetchOnTheAirTvSeries());
      context.read<PopularTvSeriesBloc>().add(const FetchPopularTvSeries());
      context.read<TopRatedTvSeriesBloc>().add(const FetchTopRatedTvSeries());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(currentRoute: AppRoutes.homeTvSeries),
      appBar: AppBar(
        title: const Text('TV Series'),
        actions: [
          IconButton(
            key: const Key('search_tv_series_button'),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.searchTvSeries);
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SubHeading(
                title: 'On The Air',
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.onTheAirTvSeries),
              ),
              BlocBuilder<OnTheAirTvSeriesBloc, TvSeriesListState>(
                builder: (context, state) => _buildSection(state),
              ),
              SubHeading(
                title: 'Popular',
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.popularTvSeries),
              ),
              BlocBuilder<PopularTvSeriesBloc, TvSeriesListState>(
                builder: (context, state) => _buildSection(state),
              ),
              SubHeading(
                title: 'Top Rated',
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.topRatedTvSeries),
              ),
              BlocBuilder<TopRatedTvSeriesBloc, TvSeriesListState>(
                builder: (context, state) => _buildSection(state),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(TvSeriesListState state) {
    return switch (state) {
      TvSeriesListLoading() => const Center(child: CircularProgressIndicator()),
      TvSeriesListHasData(:final result) => TvSeriesList(result),
      _ => const Text('Failed'),
    };
  }
}

class TvSeriesList extends StatelessWidget {
  final List<TvSeries> tvSeries;

  const TvSeriesList(this.tvSeries, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final series = tvSeries[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.tvSeriesDetail,
                  arguments: series.id,
                );
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$baseImageUrl${series.posterPath}',
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: tvSeries.length,
      ),
    );
  }
}
