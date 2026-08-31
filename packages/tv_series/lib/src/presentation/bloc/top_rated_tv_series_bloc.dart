import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_top_rated_tv_series.dart';
import 'tv_series_list_state.dart';

sealed class TopRatedTvSeriesEvent extends Equatable {
  const TopRatedTvSeriesEvent();

  @override
  List<Object?> get props => [];
}

/// Meminta daftar serial TV dengan rating tertinggi.
final class FetchTopRatedTvSeries extends TopRatedTvSeriesEvent {
  const FetchTopRatedTvSeries();
}

class TopRatedTvSeriesBloc
    extends Bloc<TopRatedTvSeriesEvent, TvSeriesListState> {
  final GetTopRatedTvSeries getTopRatedTvSeries;

  TopRatedTvSeriesBloc(this.getTopRatedTvSeries)
    : super(const TvSeriesListEmpty()) {
    on<FetchTopRatedTvSeries>((event, emit) async {
      emit(const TvSeriesListLoading());

      final result = await getTopRatedTvSeries.execute();
      result.fold(
        (failure) => emit(TvSeriesListError(failure.message)),
        (tvSeries) => emit(TvSeriesListHasData(tvSeries)),
      );
    });
  }
}
