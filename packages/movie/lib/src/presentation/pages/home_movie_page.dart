import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/movie.dart';
import '../bloc/movie_list_state.dart';
import '../bloc/now_playing_movies_bloc.dart';
import '../bloc/popular_movies_bloc.dart';
import '../bloc/top_rated_movies_bloc.dart';

class HomeMoviePage extends StatefulWidget {
  static const routeName = AppRoutes.homeMovie;

  const HomeMoviePage({super.key});

  @override
  State<HomeMoviePage> createState() => _HomeMoviePageState();
}

class _HomeMoviePageState extends State<HomeMoviePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<NowPlayingMoviesBloc>().add(const FetchNowPlayingMovies());
      context.read<PopularMoviesBloc>().add(const FetchPopularMovies());
      context.read<TopRatedMoviesBloc>().add(const FetchTopRatedMovies());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(currentRoute: AppRoutes.homeMovie),
      appBar: AppBar(
        title: const Text('Ditonton'),
        actions: [
          IconButton(
            key: const Key('search_movie_button'),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.searchMovies);
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
              Text('Now Playing', style: kHeading6),
              BlocBuilder<NowPlayingMoviesBloc, MovieListState>(
                builder: (context, state) => _buildSection(state),
              ),
              SubHeading(
                title: 'Popular',
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.popularMovies),
              ),
              BlocBuilder<PopularMoviesBloc, MovieListState>(
                builder: (context, state) => _buildSection(state),
              ),
              SubHeading(
                title: 'Top Rated',
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.topRatedMovies),
              ),
              BlocBuilder<TopRatedMoviesBloc, MovieListState>(
                builder: (context, state) => _buildSection(state),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(MovieListState state) {
    return switch (state) {
      MovieListLoading() => const Center(child: CircularProgressIndicator()),
      MovieListHasData(:final result) => MovieList(result),
      _ => const Text('Failed'),
    };
  }
}

class MovieList extends StatelessWidget {
  final List<Movie> movies;

  const MovieList(this.movies, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.movieDetail,
                  arguments: movie.id,
                );
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
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
        itemCount: movies.length,
      ),
    );
  }
}
