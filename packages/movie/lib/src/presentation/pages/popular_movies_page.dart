import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/movie_list_state.dart';
import '../bloc/popular_movies_bloc.dart';
import '../widgets/movie_card_list.dart';

class PopularMoviesPage extends StatefulWidget {
  static const routeName = AppRoutes.popularMovies;

  const PopularMoviesPage({super.key});

  @override
  State<PopularMoviesPage> createState() => _PopularMoviesPageState();
}

class _PopularMoviesPageState extends State<PopularMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<PopularMoviesBloc>().add(const FetchPopularMovies());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Popular Movies')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PopularMoviesBloc, MovieListState>(
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
