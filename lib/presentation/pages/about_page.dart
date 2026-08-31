import 'package:core/core.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  static const routeName = AppRoutes.about;

  /// Pelapor eror yang dipakai tombol uji Crashlytics.
  ///
  /// Bernilai `null` pada pengujian sehingga tombol uji tidak ditampilkan.
  final CrashReporter? crashReporter;

  const AboutPage({super.key, this.crashReporter});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Container(
                  color: kPrussianBlue,
                  child: Center(child: Image.asset(kAppLogoAsset, width: 128)),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(32.0),
                  color: kMikadoYellow,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Ditonton merupakan sebuah aplikasi katalog film dan serial TV '
                        'yang dikembangkan oleh Dicoding Indonesia sebagai contoh proyek '
                        'aplikasi untuk kelas Menjadi Flutter Developer Expert.',
                        style: TextStyle(color: Colors.black87, fontSize: 16),
                        textAlign: TextAlign.justify,
                      ),
                      if (crashReporter != null) ...[
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            OutlinedButton(
                              key: const Key('record_error_button'),
                              onPressed: () => _recordTestError(context),
                              child: const Text('Kirim Eror Uji'),
                            ),
                            const SizedBox(width: 8),
                            FilledButton(
                              key: const Key('force_crash_button'),
                              onPressed: crashReporter!.forceCrash,
                              child: const Text('Paksa Crash'),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
          SafeArea(
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
            ),
          ),
        ],
      ),
    );
  }

  /// Mengirim eror non-fatal supaya integrasi Crashlytics dapat diverifikasi
  /// tanpa harus mematikan aplikasi.
  Future<void> _recordTestError(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);

    await crashReporter!.recordError(
      Exception('Eror uji dari halaman About Ditonton'),
      StackTrace.current,
    );

    messenger.showSnackBar(
      const SnackBar(content: Text('Eror uji terkirim ke Crashlytics')),
    );
  }
}
