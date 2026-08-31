import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../domain/entities/movie.dart';
import '../../domain/entities/movie_detail.dart';
import '../bloc/movie_detail_bloc.dart';
import '../bloc/movie_list_state.dart';
import '../bloc/movie_recommendations_bloc.dart';
import '../bloc/watchlist_movie_status_bloc.dart';

class MovieDetailPage extends StatefulWidget {
  static const routeName = AppRoutes.movieDetail;

  final int id;

  const MovieDetailPage({super.key, required this.id});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<MovieDetailBloc>().add(FetchMovieDetail(widget.id));
      context.read<MovieRecommendationsBloc>().add(
        FetchMovieRecommendations(widget.id),
      );
      context.read<WatchlistMovieStatusBloc>().add(
        LoadWatchlistMovieStatus(widget.id),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MovieDetailBloc, MovieDetailState>(
        builder: (context, state) {
          return switch (state) {
            MovieDetailLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            MovieDetailHasData(:final result) => SafeArea(
              child:
                  BlocBuilder<
                    WatchlistMovieStatusBloc,
                    WatchlistMovieStatusState
                  >(
                    builder: (context, watchlistState) => DetailContent(
                      result,
                      watchlistState.isAddedToWatchlist,
                    ),
                  ),
            ),
            MovieDetailError(:final message) => Center(
              key: const Key('error_message'),
              child: Text(message),
            ),
            MovieDetailEmpty() => const SizedBox.shrink(),
          };
        },
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final MovieDetail movie;
  final bool isAddedWatchlist;

  const DetailContent(this.movie, this.isAddedWatchlist, {super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: '$baseImageUrl${movie.posterPath}',
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
                            Text(movie.title, style: kHeading5),
                            BlocListener<
                              WatchlistMovieStatusBloc,
                              WatchlistMovieStatusState
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
                            Text(_showGenres(movie.genres)),
                            Text(_showDuration(movie.runtime)),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: movie.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${movie.voteAverage}'),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text('Overview', style: kHeading6),
                            Text(movie.overview),
                            const SizedBox(height: 16),
                            Text('Recommendations', style: kHeading6),
                            BlocBuilder<
                              MovieRecommendationsBloc,
                              MovieListState
                            >(
                              builder: (context, state) {
                                return switch (state) {
                                  MovieListLoading() => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  MovieListError(:final message) => Text(
                                    message,
                                  ),
                                  MovieListHasData(:final result) =>
                                    _buildRecommendations(result),
                                  MovieListEmpty() => const SizedBox.shrink(),
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

  Widget _buildRecommendations(List<Movie> recommendations) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final movie = recommendations[index];
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: InkWell(
              key: Key('recommendation_${movie.id}'),
              onTap: () {
                Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.movieDetail,
                  arguments: movie.id,
                );
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                child: CachedNetworkImage(
                  imageUrl: '$baseImageUrl${movie.posterPath}',
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
    final bloc = context.read<WatchlistMovieStatusBloc>();

    if (isAddedWatchlist) {
      bloc.add(RemoveMovieFromWatchlist(movie));
    } else {
      bloc.add(AddMovieToWatchlist(movie));
    }
  }

  /// Menampilkan snackbar untuk operasi yang berhasil dan dialog untuk gagal.
  void _onWatchlistMessage(
    BuildContext context,
    WatchlistMovieStatusState state,
  ) {
    final message = state.message;

    if (message == WatchlistMovieStatusBloc.watchlistAddSuccessMessage ||
        message == WatchlistMovieStatusBloc.watchlistRemoveSuccessMessage) {
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

  String _showDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}
