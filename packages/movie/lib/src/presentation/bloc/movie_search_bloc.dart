import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/usecases/search_movies.dart';
import 'movie_list_state.dart';

sealed class MovieSearchEvent extends Equatable {
  const MovieSearchEvent();
}

/// Kata kunci pencarian berubah.
final class OnMovieQueryChanged extends MovieSearchEvent {
  final String query;

  const OnMovieQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

/// Menunda pemrosesan event supaya pencarian tidak dikirim pada setiap ketikan.
EventTransformer<T> debounce<T>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).switchMap(mapper);
}

class MovieSearchBloc extends Bloc<MovieSearchEvent, MovieListState> {
  static const Duration debounceDuration = Duration(milliseconds: 500);

  final SearchMovies searchMovies;

  MovieSearchBloc(this.searchMovies) : super(const MovieListEmpty()) {
    on<OnMovieQueryChanged>((event, emit) async {
      final query = event.query;
      if (query.isEmpty) {
        emit(const MovieListEmpty());
        return;
      }

      emit(const MovieListLoading());

      final result = await searchMovies.execute(query);
      result.fold(
        (failure) => emit(MovieListError(failure.message)),
        (movies) => emit(MovieListHasData(movies)),
      );
    }, transformer: debounce(debounceDuration));
  }
}
