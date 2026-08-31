import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/usecases/search_tv_series.dart';
import 'tv_series_list_state.dart';

sealed class TvSeriesSearchEvent extends Equatable {
  const TvSeriesSearchEvent();
}

/// Kata kunci pencarian berubah.
final class OnTvSeriesQueryChanged extends TvSeriesSearchEvent {
  final String query;

  const OnTvSeriesQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

/// Menunda pemrosesan event supaya pencarian tidak dikirim pada setiap ketikan.
EventTransformer<T> debounce<T>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).switchMap(mapper);
}

class TvSeriesSearchBloc extends Bloc<TvSeriesSearchEvent, TvSeriesListState> {
  static const Duration debounceDuration = Duration(milliseconds: 500);

  final SearchTvSeries searchTvSeries;

  TvSeriesSearchBloc(this.searchTvSeries) : super(const TvSeriesListEmpty()) {
    on<OnTvSeriesQueryChanged>((event, emit) async {
      final query = event.query;
      if (query.isEmpty) {
        emit(const TvSeriesListEmpty());
        return;
      }

      emit(const TvSeriesListLoading());

      final result = await searchTvSeries.execute(query);
      result.fold(
        (failure) => emit(TvSeriesListError(failure.message)),
        (tvSeries) => emit(TvSeriesListHasData(tvSeries)),
      );
    }, transformer: debounce(debounceDuration));
  }
}
