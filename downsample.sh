#!/bin/sh
# Downsample 24-bit FLACs to 16-bit recursively, with dithering applied.
usage() { printf >&2 'usage: %s DIR [DIR2..]\n' "${0##*/}"; exit; }
main() {
  case $# in
    0) usage ;;
    *) case "$1" in -h|--help) usage ;; esac ;;
  esac
  _check sox; _setvars
  for dir; do
    if test -d "$dir"; then
      _resample "$dir"
    else
      say "warning: not a directory: $dir" && continue
    fi
  done
}
die() { printf >&2 '%s: error: %s\n' "${0##*/}" "$*"; exit 2; }
say() { printf >&2 '%s: %s\n' "${0##*/}" "$*"; }
_check() {
  command -v "$1" >/dev/null 2>&1 || die "$1 is not installed!"
}
_setvars() { SOX_OPTS="--temp . --multi-threaded"; export SOX_OPTS; }
_resample() {
  find "$1" -type f -iname \*.flac | while read -r file; do
    if test "$(soxi -b "$file")" -eq 24; then
      srate="$(soxi -r "$file")"
    else
      say "wrong sampling rate: $file"
      continue
    fi
    case "$((
      srate == 44100 || srate == 88200 || srate == 176400 ? 1 :
      srate == 48000 || srate == 96000 || srate == 192000 ? 2 : 0
    ))" in
      1) sr=44100; br=16; brsr="16-44" ;;
      2) sr=48000; br=16; brsr="16-48" ;;
      0) die "incorrect sampling rate: $file" ;;
    esac
    out="${file%/*}/resampled-$brsr"
    mkdir -p "$out"
    sox "$file" -S -G -b $br "$out/${file##*/}" rate -v -L $sr dither
  done
}
main "$@"
