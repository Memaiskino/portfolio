#!/usr/bin/env bash
set -uo pipefail

# ffmpeg path (winget portable install)
FFMPEG="/c/Users/reini/AppData/Local/Microsoft/WinGet/Packages/Gyan.FFmpeg_Microsoft.Winget.Source_8wekyb3d8bbwe/ffmpeg-8.1.2-full_build/bin/ffmpeg.exe"

SRC="$(cd "$(dirname "$0")" && pwd)"
DIST="$SRC/dist"
ASSETS_SRC="$SRC/assets/final"
ASSETS_DIST="$DIST/assets/final"
ANIM_SRC="$ASSETS_SRC/anim"
ANIM_DIST="$ASSETS_DIST/anim"

echo "=== Cleaning dist/ ==="
rm -rf "$DIST"
mkdir -p "$ANIM_DIST"

echo "=== Copying HTML & static files ==="
cp "$SRC/src/index.html" "$DIST/index.html"
cp "$SRC/robots.txt" "$DIST/robots.txt"
cp "$SRC/sitemap.xml" "$DIST/sitemap.xml"
cp "$SRC/_headers" "$DIST/_headers"
# Copy favicon/og-image if they exist
[ -f "$SRC/favicon.ico" ] && cp "$SRC/favicon.ico" "$DIST/"
[ -f "$SRC/favicon.svg" ] && cp "$SRC/favicon.svg" "$DIST/"
[ -f "$SRC/og-image.jpg" ] && cp "$SRC/og-image.jpg" "$DIST/"

echo "=== Copying PNG images ==="
cp "$ASSETS_SRC"/*.png "$ASSETS_DIST/"

echo "=== Converting GIFs to MP4 + WebM ==="
GIFS=(co2 creativity distribution genders measurement tdd-innsbruck)
for name in "${GIFS[@]}"; do
  gif="$ANIM_SRC/$name.gif"
  if [ -f "$gif" ]; then
    echo "  GIF → MP4: $name"
    "$FFMPEG" -y -i "$gif" \
      -movflags faststart -pix_fmt yuv420p \
      -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" \
      "$ANIM_DIST/$name.mp4" 2>/dev/null

    echo "  GIF → WebM: $name"
    "$FFMPEG" -y -i "$gif" \
      -c:v libvpx-vp9 -b:v 0 -crf 30 \
      -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" \
      "$ANIM_DIST/$name.webm" 2>/dev/null
  fi
done

echo "=== Copying MP4s + transcoding to WebM ==="
for mp4 in "$ANIM_SRC"/*.mp4; do
  name=$(basename "$mp4")
  base="${name%.mp4}"
  echo "  Copy MP4: $name"
  cp "$mp4" "$ANIM_DIST/$name"

  echo "  MP4 → WebM: $base"
  "$FFMPEG" -y -i "$mp4" \
    -c:v libvpx-vp9 -b:v 0 -crf 30 -an \
    "$ANIM_DIST/$base.webm" 2>/dev/null
done

echo "=== Extracting poster frames ==="
for mp4 in "$ANIM_DIST"/*.mp4; do
  base="${mp4%.mp4}"
  echo "  Poster: $(basename "$mp4")"
  "$FFMPEG" -y -i "$mp4" -vframes 1 -q:v 2 "${base}-poster.jpg" 2>/dev/null
done

echo "=== Done! ==="
echo "Output in: $DIST"
du -sh "$DIST"
