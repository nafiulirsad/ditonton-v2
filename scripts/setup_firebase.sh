#!/usr/bin/env bash
#
# Menyiapkan Firebase (Analytics + Crashlytics) untuk aplikasi Ditonton.
#
# Prasyarat:
#   npm install -g firebase-tools
#   dart pub global activate flutterfire_cli
#
# Langkah yang dijalankan skrip ini:
#   1. login ke akun Google (browser akan terbuka)
#   2. membuat/memilih project Firebase
#   3. membuat berkas lib/firebase_options.dart, android/app/google-services.json,
#      dan ios/Runner/GoogleService-Info.plist
#   4. memasang Gradle plugin google-services serta crashlytics
#
# Pemakaian:
#   ./scripts/setup_firebase.sh [project-id]

set -euo pipefail

readonly PROJECT_ID="${1:-ditonton-dicoding}"
readonly ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

export PATH="$PATH:$HOME/.pub-cache/bin"

cd "$ROOT_DIR"

echo "==> memastikan akun Google sudah masuk"
if ! firebase login:list | grep -q '@'; then
  firebase login
fi

echo "==> membuat project $PROJECT_ID bila belum ada"
firebase projects:create "$PROJECT_ID" --display-name "Ditonton" || \
  echo "project sudah ada atau id terpakai, lanjut memakai project tersebut"

echo "==> menghubungkan aplikasi Flutter dengan Firebase"
flutterfire configure \
  --project="$PROJECT_ID" \
  --platforms=android,ios \
  --android-package-name=com.dicoding.ditonton \
  --ios-bundle-id=com.dicoding.ditonton \
  --yes

echo
echo "Selesai. Langkah berikutnya:"
echo "  1. flutter run                       # jalankan aplikasi"
echo "  2. buka menu About lalu tekan"
echo "     'Kirim Eror Uji' dan 'Paksa Crash' untuk mengisi Crashlytics"
echo "  3. buka https://console.firebase.google.com/project/$PROJECT_ID"
echo "     untuk mengambil screenshot Analytics dan Crashlytics"
