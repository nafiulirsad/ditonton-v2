import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_movie_recommendations.dart';
import 'movie_list_state.dart';

sealed class MovieRecommendationsEvent extends Equatable {
  const MovieRecommendationsEvent();
}

/// Meminta rekomendasi film untuk film dengan [id].
final class FetchMovieRecommendations extends MovieRecommendationsEvent {
  final int id;

  const FetchMovieRecommendations(this.id);

  @override
  List<Object?> get props => [id];
}

class MovieRecommendationsBloc
    extends Bloc<MovieRecommendationsEvent, MovieListState> {
  final GetMovieRecommendations getMovieRecommendations;

  MovieRecommendationsBloc(this.getMovieRecommendations)
    : super(const MovieListEmpty()) {
    on<FetchMovieRecommendations>((event, emit) async {
      emit(const MovieListLoading());

      final result = await getMovieRecommendations.execute(event.id);
      result.fold(
        (failure) => emit(MovieListError(failure.message)),
        (movies) => emit(MovieListHasData(movies)),
      );
    });
  }
}
