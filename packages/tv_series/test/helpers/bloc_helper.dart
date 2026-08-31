import 'package:bloc_test/bloc_test.dart';
import 'package:tv_series/tv_series.dart';

/// Mock bloc untuk pengujian widget modul tv_series.
class MockOnTheAirTvSeriesBloc
    extends MockBloc<OnTheAirTvSeriesEvent, TvSeriesListState>
    implements OnTheAirTvSeriesBloc {}

class MockPopularTvSeriesBloc
    extends MockBloc<PopularTvSeriesEvent, TvSeriesListState>
    implements PopularTvSeriesBloc {}

class MockTopRatedTvSeriesBloc
    extends MockBloc<TopRatedTvSeriesEvent, TvSeriesListState>
    implements TopRatedTvSeriesBloc {}

class MockTvSeriesSearchBloc
    extends MockBloc<TvSeriesSearchEvent, TvSeriesListState>
    implements TvSeriesSearchBloc {}

class MockWatchlistTvSeriesBloc
    extends MockBloc<WatchlistTvSeriesEvent, TvSeriesListState>
    implements WatchlistTvSeriesBloc {}

class MockTvSeriesDetailBloc
    extends MockBloc<TvSeriesDetailEvent, TvSeriesDetailState>
    implements TvSeriesDetailBloc {}

class MockTvSeriesRecommendationsBloc
    extends MockBloc<TvSeriesRecommendationsEvent, TvSeriesListState>
    implements TvSeriesRecommendationsBloc {}

class MockWatchlistTvSeriesStatusBloc
    extends MockBloc<WatchlistTvSeriesStatusEvent, WatchlistTvSeriesStatusState>
    implements WatchlistTvSeriesStatusBloc {}

class MockSeasonDetailBloc
    extends MockBloc<SeasonDetailEvent, SeasonDetailState>
    implements SeasonDetailBloc {}
