/// Konfigurasi endpoint The Movie Database.
///
/// Kunci API dapat ditimpa saat proses build tanpa mengubah kode, contoh:
/// `flutter run --dart-define=TMDB_API_KEY=<kunci-anda>`.
abstract final class TmdbApi {
  static const String _defaultApiKey = '2174d146bb9c0eab47529b2e77d6b526';

  static const String apiKey =
      'api_key='
      '${String.fromEnvironment('TMDB_API_KEY', defaultValue: _defaultApiKey)}';

  static const String baseUrl = 'https://api.themoviedb.org/3';
}
