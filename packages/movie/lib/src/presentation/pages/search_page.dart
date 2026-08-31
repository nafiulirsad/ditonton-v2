import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/movie_list_state.dart';
import '../bloc/movie_search_bloc.dart';
import '../widgets/movie_card_list.dart';

class SearchPage extends StatelessWidget {
  static const routeName = AppRoutes.searchMovies;

  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Movies')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              key: const Key('query_input'),
              onChanged: (query) {
                context.read<MovieSearchBloc>().add(OnMovieQueryChanged(query));
              },
              onSubmitted: (query) {
                context.read<MovieSearchBloc>().add(OnMovieQueryChanged(query));
              },
              decoration: const InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            const SizedBox(height: 16),
            Text('Search Result', style: kHeading6),
            BlocBuilder<MovieSearchBloc, MovieListState>(
              builder: (context, state) {
                return switch (state) {
                  MovieListLoading() => const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  MovieListHasData(:final result) => Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (context, index) => MovieCard(result[index]),
                      itemCount: result.length,
                    ),
                  ),
                  MovieListError(:final message) => Expanded(
                    child: Center(
                      key: const Key('error_message'),
                      child: Text(message),
                    ),
                  ),
                  MovieListEmpty() => const Expanded(child: SizedBox.shrink()),
                };
              },
            ),
          ],
        ),
      ),
    );
  }
}
