/// Dilempar ketika sumber data remote mengembalikan respons yang tidak valid.
class ServerException implements Exception {}

/// Dilempar ketika operasi pada basis data lokal gagal.
class DatabaseException implements Exception {
  final String message;

  const DatabaseException(this.message);
}
