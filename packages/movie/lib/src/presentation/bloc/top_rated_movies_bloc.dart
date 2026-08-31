import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_top_rated_movies.dart';
import 'movie_list_state.dart';

sealed class TopRatedMoviesEvent extends Equatable {
  const TopRatedMoviesEvent();

  @override
  List<Object?> get props => [];
}

/// Meminta daftar film dengan rating tertinggi.
final class FetchTopRatedMovies extends TopRatedMoviesEvent {
  const FetchTopRatedMovies();
}

class TopRatedMoviesBloc extends Bloc<TopRatedMoviesEvent, MovieListState> {
  final GetTopRatedMovies getTopRatedMovies;

  TopRatedMoviesBloc(this.getTopRatedMovies) : super(const MovieListEmpty()) {
    on<FetchTopRatedMovies>((event, emit) async {
      emit(const MovieListLoading());

      final result = await getTopRatedMovies.execute();
      result.fold(
        (failure) => emit(MovieListError(failure.message)),
        (movies) => emit(MovieListHasData(movies)),
      );
    });
  }
}
