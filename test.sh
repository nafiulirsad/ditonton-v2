#!/usr/bin/env bash
#
# Menjalankan seluruh pengujian pada aplikasi beserta modulnya, lalu
# menggabungkan laporan coverage tiap modul menjadi satu berkas
# `coverage/lcov.info` pada root proyek.
#
# Pemakaian:
#   ./test.sh            jalankan semua modul
#   ./test.sh --help     tampilkan bantuan

set -u

readonly ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly PACKAGES=("packages/core" "packages/movie" "packages/tv_series" ".")
readonly MERGED="$ROOT_DIR/coverage/lcov.info"

# Berkas hasil generator tidak ikut dihitung pada laporan coverage.
readonly IGNORED_PATTERNS=("\.mocks\.dart$" "\.g\.dart$" "firebase_options\.dart$")

show_help() {
  sed -n '2,10p' "${BASH_SOURCE[0]}"
  exit 0
}

[[ "${1:-}" == "--help" ]] && show_help

error=false

run_package() {
  local package="$1"
  echo "==> menjalankan pengujian pada ${package}"

  (
    cd "$ROOT_DIR/$package" || exit 1
    flutter pub get >/dev/null || exit 1
    flutter test --coverage
  ) || error=true
}

merge_coverage() {
  local package="$1"
  local lcov="$ROOT_DIR/$package/coverage/lcov.info"
  [[ -f "$lcov" ]] || return 0

  local prefix=""
  [[ "$package" != "." ]] && prefix="$package/"

  awk -v prefix="$prefix" '
    /^SF:/ { sub(/^SF:/, "SF:" prefix); }
    { print }
  ' "$lcov" >>"$MERGED.tmp"
}

filter_generated() {
  awk -v patterns="${IGNORED_PATTERNS[*]}" '
    BEGIN { split(patterns, ignored, " ") }
    /^SF:/ {
      skip = 0
      for (i in ignored) if ($0 ~ ignored[i]) skip = 1
    }
    skip == 0 { print }
  ' "$MERGED.tmp" >"$MERGED"
  rm -f "$MERGED.tmp"
}

report() {
  python3 - "$MERGED" <<'PY'
import sys

hit = found = 0
with open(sys.argv[1]) as report:
    for line in report:
        if line.startswith('DA:'):
            _, count = line[3:].strip().split(',')
            found += 1
            hit += 1 if int(count) > 0 else 0

percentage = 100 * hit / found if found else 0
print(f'coverage: {hit}/{found} baris = {percentage:.2f}%')
PY
}

mkdir -p "$ROOT_DIR/coverage"
rm -f "$MERGED" "$MERGED.tmp"

for package in "${PACKAGES[@]}"; do
  run_package "$package"
  merge_coverage "$package"
done

filter_generated
report

if [ "$error" = true ]; then
  echo "beberapa pengujian gagal" >&2
  exit 1
fi
