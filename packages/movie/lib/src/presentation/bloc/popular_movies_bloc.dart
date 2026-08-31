import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_popular_movies.dart';
import 'movie_list_state.dart';

sealed class PopularMoviesEvent extends Equatable {
  const PopularMoviesEvent();

  @override
  List<Object?> get props => [];
}

/// Meminta daftar film populer.
final class FetchPopularMovies extends PopularMoviesEvent {
  const FetchPopularMovies();
}

class PopularMoviesBloc extends Bloc<PopularMoviesEvent, MovieListState> {
  final GetPopularMovies getPopularMovies;

  PopularMoviesBloc(this.getPopularMovies) : super(const MovieListEmpty()) {
    on<FetchPopularMovies>((event, emit) async {
      emit(const MovieListLoading());

      final result = await getPopularMovies.execute();
      result.fold(
        (failure) => emit(MovieListError(failure.message)),
        (movies) => emit(MovieListHasData(movies)),
      );
    });
  }
}
