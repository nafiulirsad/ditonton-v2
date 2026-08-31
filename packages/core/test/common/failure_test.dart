import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should compare failures by their message', () {
    expect(const ServerFailure('a'), const ServerFailure('a'));
    expect(const ServerFailure('a'), isNot(const ServerFailure('b')));
    expect(const ConnectionFailure('a').props, ['a']);
    expect(const DatabaseFailure('a').message, 'a');
  });

  test('should keep the message of a database exception', () {
    const exception = DatabaseException('failed');

    expect(exception.message, 'failed');
    expect(ServerException(), isA<Exception>());
  });

  test('should expose the connection failure message', () {
    expect(kConnectionFailureMessage, 'Failed to connect to the network');
  });

  test('should expose a route observer for the whole application', () {
    expect(routeObserver, isNotNull);
  });

  test('should expose the TMDB endpoint configuration', () {
    expect(TmdbApi.baseUrl, 'https://api.themoviedb.org/3');
    expect(TmdbApi.apiKey, startsWith('api_key='));
    expect(AppRoutes.homeMovie, '/home');
  });
}
