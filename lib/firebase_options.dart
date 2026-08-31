// Berkas ini akan ditimpa oleh `flutterfire configure`.
//
// Selama konfigurasi Firebase belum dibuat, [DefaultFirebaseOptions] melempar
// [UnsupportedError] dan aplikasi tetap berjalan tanpa Analytics/Crashlytics.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

abstract final class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform => throw UnsupportedError(
    'Konfigurasi Firebase belum tersedia. '
    'Jalankan `flutterfire configure` untuk membuat firebase_options.dart.',
  );
}
