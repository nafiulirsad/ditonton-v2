import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/tv_series_list_state.dart';
import '../bloc/tv_series_search_bloc.dart';
import '../widgets/tv_series_card_list.dart';

class SearchTvSeriesPage extends StatelessWidget {
  static const routeName = AppRoutes.searchTvSeries;

  const SearchTvSeriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search TV Series')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              key: const Key('query_input'),
              onChanged: (query) {
                context.read<TvSeriesSearchBloc>().add(
                  OnTvSeriesQueryChanged(query),
                );
              },
              onSubmitted: (query) {
                context.read<TvSeriesSearchBloc>().add(
                  OnTvSeriesQueryChanged(query),
                );
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
            BlocBuilder<TvSeriesSearchBloc, TvSeriesListState>(
              builder: (context, state) {
                return switch (state) {
                  TvSeriesListLoading() => const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  TvSeriesListHasData(:final result) => Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (context, index) =>
                          TvSeriesCard(result[index]),
                      itemCount: result.length,
                    ),
                  ),
                  TvSeriesListError(:final message) => Expanded(
                    child: Center(
                      key: const Key('error_message'),
                      child: Text(message),
                    ),
                  ),
                  TvSeriesListEmpty() => const Expanded(
                    child: SizedBox.shrink(),
                  ),
                };
              },
            ),
          ],
        ),
      ),
    );
  }
}
