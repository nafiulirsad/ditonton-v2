import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_on_the_air_tv_series.dart';
import 'tv_series_list_state.dart';

sealed class OnTheAirTvSeriesEvent extends Equatable {
  const OnTheAirTvSeriesEvent();

  @override
  List<Object?> get props => [];
}

/// Meminta daftar serial TV yang sedang tayang.
final class FetchOnTheAirTvSeries extends OnTheAirTvSeriesEvent {
  const FetchOnTheAirTvSeries();
}

class OnTheAirTvSeriesBloc
    extends Bloc<OnTheAirTvSeriesEvent, TvSeriesListState> {
  final GetOnTheAirTvSeries getOnTheAirTvSeries;

  OnTheAirTvSeriesBloc(this.getOnTheAirTvSeries)
    : super(const TvSeriesListEmpty()) {
    on<FetchOnTheAirTvSeries>((event, emit) async {
      emit(const TvSeriesListLoading());

      final result = await getOnTheAirTvSeries.execute();
      result.fold(
        (failure) => emit(TvSeriesListError(failure.message)),
        (tvSeries) => emit(TvSeriesListHasData(tvSeries)),
      );
    });
  }
}
