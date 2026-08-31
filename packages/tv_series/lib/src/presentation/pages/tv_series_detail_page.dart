import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../domain/entities/season.dart';
import '../../domain/entities/tv_series.dart';
import '../../domain/entities/tv_series_detail.dart';
import '../bloc/tv_series_detail_bloc.dart';
import '../bloc/tv_series_list_state.dart';
import '../bloc/tv_series_recommendations_bloc.dart';
import '../bloc/watchlist_tv_series_status_bloc.dart';
import 'season_detail_page.dart';

class TvSeriesDetailPage extends StatefulWidget {
  static const routeName = AppRoutes.tvSeriesDetail;

  final int id;

  const TvSeriesDetailPage({super.key, required this.id});

  @override
  State<TvSeriesDetailPage> createState() => _TvSeriesDetailPageState();
}

class _TvSeriesDetailPageState extends State<TvSeriesDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<TvSeriesDetailBloc>().add(FetchTvSeriesDetail(widget.id));
      context.read<TvSeriesRecommendationsBloc>().add(
        FetchTvSeriesRecommendations(widget.id),
      );
      context.read<WatchlistTvSeriesStatusBloc>().add(
        LoadWatchlistTvSeriesStatus(widget.id),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TvSeriesDetailBloc, TvSeriesDetailState>(
        builder: (context, state) {
          return switch (state) {
            TvSeriesDetailLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            TvSeriesDetailHasData(:final result) => SafeArea(
              child:
                  BlocBuilder<
                    WatchlistTvSeriesStatusBloc,
                    WatchlistTvSeriesStatusState
                  >(
                    builder: (context, watchlistState) => TvSeriesDetailContent(
                      result,
                      watchlistState.isAddedToWatchlist,
                    ),
                  ),
            ),
            TvSeriesDetailError(:final message) => Center(
              key: const Key('error_message'),
              child: Text(message),
            ),
            TvSeriesDetailEmpty() => const SizedBox.shrink(),
          };
        },
      ),
    );
  }
}

class TvSeriesDetailContent extends StatelessWidget {
  final TvSeriesDetail tvSeries;
  final bool isAddedWatchlist;

  const TvSeriesDetailContent(
    this.tvSeries,
    this.isAddedWatchlist, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: '$baseImageUrl${tvSeries.posterPath}',
          width: screenWidth,
          placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            minChildSize: 0.25,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(tvSeries.name, style: kHeading5),
                            BlocListener<
                              WatchlistTvSeriesStatusBloc,
                              WatchlistTvSeriesStatusState
                            >(
                              listenWhen: (previous, current) =>
                                  previous.message != current.message &&
                                  current.message.isNotEmpty,
                              listener: _onWatchlistMessage,
                              child: FilledButton(
                                key: const Key('watchlist_button'),
                                onPressed: () => _onWatchlistPressed(context),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    isAddedWatchlist
                                        ? const Icon(Icons.check)
                                        : const Icon(Icons.add),
                                    const Text('Watchlist'),
                                  ],
                                ),
                              ),
                            ),
                            Text(_showGenres(tvSeries.genres)),
                            Text(_showEpisodeRunTime(tvSeries.episodeRunTime)),
                            Text(
                              '${tvSeries.numberOfSeasons} Season | '
                              '${tvSeries.numberOfEpisodes} Episode | '
                              '${tvSeries.status}',
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: tvSeries.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${tvSeries.voteAverage}'),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text('Overview', style: kHeading6),
                            Text(
                              tvSeries.overview.isEmpty
                                  ? 'Tidak ada sinopsis untuk serial ini.'
                                  : tvSeries.overview,
                            ),
                            const SizedBox(height: 16),
                            Text('Seasons', style: kHeading6),
                            _buildSeasons(context),
                            const SizedBox(height: 16),
                            Text('Recommendations', style: kHeading6),
                            BlocBuilder<
                              TvSeriesRecommendationsBloc,
                              TvSeriesListState
                            >(
                              builder: (context, state) {
                                return switch (state) {
                                  TvSeriesListLoading() => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  TvSeriesListError(:final message) => Text(
                                    message,
                                  ),
                                  TvSeriesListHasData(:final result) =>
                                    _buildRecommendations(result),
                                  TvSeriesListEmpty() =>
                                    const SizedBox.shrink(),
                                };
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSeasons(BuildContext context) {
    if (tvSeries.seasons.isEmpty) {
      return const Text('Tidak ada informasi season.');
    }

    return SizedBox(
      height: 240,
      child: ListView.builder(
        key: const Key('season_list'),
        scrollDirection: Axis.horizontal,
        itemCount: tvSeries.seasons.length,
        itemBuilder: (context, index) {
          final season = tvSeries.seasons[index];
          return _SeasonCard(tvSeriesId: tvSeries.id, season: season);
        },
      ),
    );
  }

  Widget _buildRecommendations(List<TvSeries> recommendations) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final series = recommendations[index];
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: InkWell(
              key: Key('recommendation_${series.id}'),
              onTap: () {
                Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.tvSeriesDetail,
                  arguments: series.id,
                );
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
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
        itemCount: recommendations.length,
      ),
    );
  }

  void _onWatchlistPressed(BuildContext context) {
    final bloc = context.read<WatchlistTvSeriesStatusBloc>();

    if (isAddedWatchlist) {
      bloc.add(RemoveTvSeriesFromWatchlist(tvSeries));
    } else {
      bloc.add(AddTvSeriesToWatchlist(tvSeries));
    }
  }

  /// Menampilkan snackbar untuk operasi yang berhasil dan dialog untuk gagal.
  void _onWatchlistMessage(
    BuildContext context,
    WatchlistTvSeriesStatusState state,
  ) {
    final message = state.message;

    if (message == WatchlistTvSeriesStatusBloc.watchlistAddSuccessMessage ||
        message == WatchlistTvSeriesStatusBloc.watchlistRemoveSuccessMessage) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } else {
      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(content: Text(message)),
      );
    }
  }

  String _showGenres(List<Genre> genres) {
    return genres.map((genre) => genre.name).join(', ');
  }

  String _showEpisodeRunTime(List<int> episodeRunTime) {
    if (episodeRunTime.isEmpty) {
      return 'Durasi tidak diketahui';
    }
    return '${episodeRunTime.first}m per episode';
  }
}

class _SeasonCard extends StatelessWidget {
  final int tvSeriesId;
  final Season season;

  const _SeasonCard({required this.tvSeriesId, required this.season});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: InkWell(
        key: Key('season_card_${season.seasonNumber}'),
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.seasonDetail,
            arguments: SeasonDetailArgs(
              tvSeriesId: tvSeriesId,
              seasonNumber: season.seasonNumber,
              seasonName: season.name,
            ),
          );
        },
        child: SizedBox(
          width: 110,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                child: CachedNetworkImage(
                  imageUrl: '$baseImageUrl${season.posterPath}',
                  height: 150,
                  width: 110,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                season.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: kSubtitle,
              ),
              Text('${season.episodeCount} Episode', style: kBodyText),
            ],
          ),
        ),
      ),
    );
  }
}
