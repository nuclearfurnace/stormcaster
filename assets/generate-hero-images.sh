#!/bin/bash

STORM_EXTRACT_BIN="node_modules/storm-extract/bin/storm-extract"

# Make sure we have storm-extract installed and compiled.
yarn install
if [ ! -f $STORM_EXTRACT_BIN ]; then
  pushd .
  cd node_modules/storm-extract
  cmake .
  make
  popd
fi

# Find all of the replay-style hero images and extract them.
$STORM_EXTRACT_BIN -i "/Applications/Heroes of the Storm/HeroesData" -s leaderboard -o hero_images -x

# Convert from DDS (DirectDraw Surface, GPU-optimized format) to PNG, via ImageMagick.
mkdir static/images/heroes
for image in $(find hero_images -name storm_ui_ingame_hero_leaderboard_*.dds); do
  convert "$image" static/images/heroes/"$(basename "$image" .dds)".png
done

rm -rf hero_images
echo "Done."
