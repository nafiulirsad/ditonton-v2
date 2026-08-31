import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_watchlist_tv_series.dart';
import 'tv_series_list_state.dart';

sealed class WatchlistTvSeriesEvent extends Equatable {
  const WatchlistTvSeriesEvent();

  @override
  List<Object?> get props => [];
}

/// Meminta daftar serial TV pada watchlist.
final class FetchWatchlistTvSeries extends WatchlistTvSeriesEvent {
  const FetchWatchlistTvSeries();
}

class WatchlistTvSeriesBloc
    extends Bloc<WatchlistTvSeriesEvent, TvSeriesListState> {
  final GetWatchlistTvSeries getWatchlistTvSeries;

  WatchlistTvSeriesBloc(this.getWatchlistTvSeries)
    : super(const TvSeriesListEmpty()) {
    on<FetchWatchlistTvSeries>((event, emit) async {
      emit(const TvSeriesListLoading());

      final result = await getWatchlistTvSeries.execute();
      result.fold(
        (failure) => emit(TvSeriesListError(failure.message)),
        (tvSeries) => emit(TvSeriesListHasData(tvSeries)),
      );
    });
  }
}
