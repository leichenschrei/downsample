#!/bin/sh
# Downsample 24-bit FLACs to 16-bit recursively, with dithering applied.
main() { for dir; do test -d "$dir" && _resample "$dir"; done; }
die() { printf >&2 '%s: error: %s\n' "${0##*/}" "$*"; exit 2; }
say() { printf >&2 '%s: %s\n' "${0##*/}" "$*"; }
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