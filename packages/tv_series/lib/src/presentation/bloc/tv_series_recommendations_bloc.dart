import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_tv_series_recommendations.dart';
import 'tv_series_list_state.dart';

sealed class TvSeriesRecommendationsEvent extends Equatable {
  const TvSeriesRecommendationsEvent();
}

/// Meminta rekomendasi serial TV untuk serial dengan [id].
final class FetchTvSeriesRecommendations extends TvSeriesRecommendationsEvent {
  final int id;

  const FetchTvSeriesRecommendations(this.id);

  @override
  List<Object?> get props => [id];
}

class TvSeriesRecommendationsBloc
    extends Bloc<TvSeriesRecommendationsEvent, TvSeriesListState> {
  final GetTvSeriesRecommendations getTvSeriesRecommendations;

  TvSeriesRecommendationsBloc(this.getTvSeriesRecommendations)
    : super(const TvSeriesListEmpty()) {
    on<FetchTvSeriesRecommendations>((event, emit) async {
      emit(const TvSeriesListLoading());

      final result = await getTvSeriesRecommendations.execute(event.id);
      result.fold(
        (failure) => emit(TvSeriesListError(failure.message)),
        (tvSeries) => emit(TvSeriesListHasData(tvSeries)),
      );
    });
  }
}
