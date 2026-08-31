# Ditonton

[![Ditonton CI](https://github.com/nafiulirsad/ditonton-v2/actions/workflows/ci.yml/badge.svg)](https://github.com/nafiulirsad/ditonton-v2/actions/workflows/ci.yml)

<!--
Badge Codemagic aktif setelah repository ini ditambahkan pada https://codemagic.io.
Ganti CODEMAGIC_APP_ID dengan id aplikasi dari dashboard Codemagic lalu hapus komentar ini:

[![Codemagic build status](https://api.codemagic.io/apps/CODEMAGIC_APP_ID/ditonton-test/status_badge.svg)](https://codemagic.io/apps/CODEMAGIC_APP_ID/ditonton-test/latest_build)
-->

Aplikasi katalog **film** dan **serial TV** yang datanya berasal dari
[The Movie Database (TMDB)](https://www.themoviedb.org/). Proyek ini merupakan
submission akhir kelas **Menjadi Flutter Developer Expert** (Dicoding):
aplikasi Ditonton disiapkan agar benar-benar siap rilis melalui modularisasi,
state management **BLoC**, **SSL pinning**, integrasi **Firebase Analytics &
Crashlytics**, serta **continuous integration**.

---

## ✨ Fitur

### Film
- Daftar film **Now Playing**, **Popular**, dan **Top Rated** pada satu halaman utama.
- Halaman tersendiri untuk daftar Popular dan Top Rated.
- Halaman detail berisi poster, judul, genre, durasi, rating, sinopsis, dan rekomendasi.
- Pencarian film berdasarkan judul melalui API TMDB (dengan debounce 500 ms).
- Watchlist film yang disimpan secara lokal (SQLite).

### TV Series
- Daftar serial TV **On The Air**, **Popular**, dan **Top Rated** pada satu halaman utama.
- Halaman tersendiri untuk daftar On The Air, Popular, dan Top Rated.
- Halaman detail berisi poster, nama, genre, durasi episode, jumlah season & episode,
  status, rating, sinopsis, serta rekomendasi serial lain.
- **Informasi season & episode** (kriteria opsional): daftar season pada halaman detail
  dan halaman detail season yang menampilkan seluruh episode beserta gambar, tanggal
  tayang, rating, dan sinopsisnya.
- Pencarian serial TV berdasarkan judul melalui API TMDB.
- Watchlist serial TV yang disimpan secara lokal (SQLite).

Watchlist film dan serial TV ditampilkan pada satu halaman dengan dua tab.

---

## 🧱 Modularisasi

Aplikasi dipecah menjadi tiga package lokal yang berdiri sendiri. Setiap modul
memiliki `pubspec.yaml`, pengujian, dan laporan coverage sendiri.

```
Ditonton/
├── lib/                        # shell aplikasi: routing, DI, halaman lintas fitur
│   ├── common/app_router.dart  # satu-satunya berkas yang mengenal seluruh modul
│   ├── injection.dart          # registrasi dependensi core + memanggil tiap modul
│   ├── firebase_options.dart   # dibuat oleh `flutterfire configure`
│   └── main.dart
└── packages/
    ├── core/                   # konstanta & tema, error, DatabaseHelper,
    │                           # SSL pinning, layanan Firebase, widget bersama
    ├── movie/                  # fitur film (data, domain, presentation)
    └── tv_series/              # fitur serial TV (data, domain, presentation)
```

Tiap modul fitur menerapkan **Clean Architecture**:

```
packages/movie/lib/src/
├── data/           # model, remote & local data source, implementasi repository
├── domain/         # entity, kontrak repository, use case
├── presentation/   # bloc, halaman, widget
└── injection.dart  # registerMovieDependencies(locator)
```

Modul `core` tidak bergantung pada modul fitur mana pun. Sebaliknya, modul fitur
hanya bergantung pada `core`, sehingga `movie` dan `tv_series` dapat dikembangkan
maupun diuji secara terpisah.

---

## 🧠 State Management: BLoC

Seluruh `ChangeNotifier`/`provider` pada submission sebelumnya telah diganti
`flutter_bloc`. Satu bloc bertanggung jawab atas satu kebutuhan data:

| Modul | Bloc |
|---|---|
| movie | `NowPlayingMoviesBloc`, `PopularMoviesBloc`, `TopRatedMoviesBloc`, `MovieSearchBloc`, `MovieDetailBloc`, `MovieRecommendationsBloc`, `WatchlistMoviesBloc`, `WatchlistMovieStatusBloc` |
| tv_series | `OnTheAirTvSeriesBloc`, `PopularTvSeriesBloc`, `TopRatedTvSeriesBloc`, `TvSeriesSearchBloc`, `TvSeriesDetailBloc`, `TvSeriesRecommendationsBloc`, `WatchlistTvSeriesBloc`, `WatchlistTvSeriesStatusBloc`, `SeasonDetailBloc` |

Catatan penerapan:
- State dibentuk dari `sealed class` sehingga `switch` pada widget bersifat exhaustive.
- Bloc daftar film/serial memakai satu state bersama (`MovieListState`/`TvSeriesListState`).
- Bloc pencarian memakai `EventTransformer` **debounce 500 ms** (rxdart) supaya
  permintaan tidak dikirim pada setiap ketikan.

---

## 🔒 SSL Pinning

Permintaan ke API TMDB memakai `http.Client` yang dibangun
`SslPinningHttpClient.create()` (modul `core`):

- `SecurityContext(withTrustedRoots: false)` mematikan seluruh certificate
  authority bawaan sistem.
- Hanya sertifikat pada `packages/core/assets/certificates/tmdb.pem`
  (Amazon Root CA 1 + intermediate milik `api.themoviedb.org`) yang dipercaya.
- `badCertificateCallback` selalu mengembalikan `false`, sehingga koneksi yang
  sertifikatnya tidak lolos verifikasi — termasuk proxy penyadap — langsung ditolak.

Pengujian `packages/core/test/network/ssl_pinning_http_client_test.dart`
menjalankan server HTTPS lokal bersertifikat lain dan memastikan permintaan
ditolak dengan `HandshakeException`.

---

## 📈 Firebase Analytics & Crashlytics

- `FirebaseAnalyticsObserver` dipasang pada `MaterialApp` sehingga setiap
  perpindahan halaman tercatat sebagai `screen_view`.
- `registerCrashHandlers` menyambungkan `FlutterError.onError` dan
  `PlatformDispatcher.instance.onError` ke Crashlytics.
- Halaman **About** memuat dua tombol uji: `Kirim Eror Uji` (non-fatal) dan
  `Paksa Crash` (fatal) untuk memverifikasi laporan yang masuk ke console.

Menyiapkan Firebase pada mesin baru:

```bash
npm install -g firebase-tools
dart pub global activate flutterfire_cli
./scripts/setup_firebase.sh <project-id>
```

Skrip tersebut membuat `lib/firebase_options.dart`,
`android/app/google-services.json`, dan `ios/Runner/GoogleService-Info.plist`.
Selama berkas tersebut belum ada, aplikasi tetap berjalan: inisialisasi Firebase
dibungkus `try/catch` dan Analytics/Crashlytics dinonaktifkan.

---

## 🔁 Continuous Integration

| Layanan | Berkas | Isi |
|---|---|---|
| GitHub Actions | `.github/workflows/ci.yml` | `dart format`, `flutter analyze`, `./test.sh` (unit + widget + coverage), build APK release |
| Codemagic | `codemagic.yaml` | analisis, pengujian beserta coverage, build APK release |

Keduanya berjalan otomatis pada setiap `push` maupun `pull request`.

---

## 🧪 Pengujian

```bash
./test.sh            # seluruh modul + gabungan coverage pada coverage/lcov.info
```

Menjalankan satu modul saja:

```bash
cd packages/movie && flutter test
```

Integration test (perlu perangkat/emulator):

```bash
flutter test integration_test/app_test.dart
```

Hasil terakhir pada mesin pengembangan:

| Modul | Test | Coverage |
|---|---|---|
| core | 33 | 100 % |
| movie | 157 | 99 % |
| tv_series | 184 | 99 % |
| aplikasi | 19 | 94 % |
| **total** | **393** | **99,19 %** |

Berkas hasil generator (`*.mocks.dart`, `*.g.dart`, `firebase_options.dart`)
tidak dihitung pada laporan coverage.

---

## 🚀 Menjalankan Aplikasi

```bash
# 1. ambil dependensi seluruh modul
for package in packages/core packages/movie packages/tv_series .; do
  (cd "$package" && flutter pub get)
done

# 2. jalankan aplikasi
flutter run
```

Kunci API TMDB bawaan sudah tertanam. Untuk memakai kunci sendiri:

```bash
flutter run --dart-define=TMDB_API_KEY=<kunci-anda>
```

---

## 🛠️ Tech Stack

| Kebutuhan | Paket |
|---|---|
| State management | `flutter_bloc`, `bloc_test` |
| Dependency injection | `get_it` |
| Networking | `http` (+ SSL pinning `dart:io`) |
| Functional error handling | `dartz`, `equatable` |
| Basis data lokal | `sqflite`, `sqflite_common_ffi` (test) |
| Debounce pencarian | `rxdart` |
| Firebase | `firebase_core`, `firebase_analytics`, `firebase_crashlytics` |
| Gambar & font | `cached_network_image`, `google_fonts` (Poppins dibundel) |
| Pengujian | `flutter_test`, `integration_test`, `mockito`, `mocktail` |

Flutter 3.44.5 · Dart 3.12.2
