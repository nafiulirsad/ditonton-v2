import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/movie_list_state.dart';
import '../bloc/top_rated_movies_bloc.dart';
import '../widgets/movie_card_list.dart';

class TopRatedMoviesPage extends StatefulWidget {
  static const routeName = AppRoutes.topRatedMovies;

  const TopRatedMoviesPage({super.key});

  @override
  State<TopRatedMoviesPage> createState() => _TopRatedMoviesPageState();
}

class _TopRatedMoviesPageState extends State<TopRatedMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<TopRatedMoviesBloc>().add(const FetchTopRatedMovies());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Top Rated Movies')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TopRatedMoviesBloc, MovieListState>(
          builder: (context, state) {
            return switch (state) {
              MovieListLoading() => const Center(
                child: CircularProgressIndicator(),
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
      ),
    );
  }
}
