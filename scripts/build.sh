#!/bin/sh
CUR_DIR="$(pwd)"
DIST_DIR="$(pwd)/dist"
TAG="$(git describe --tags --abbrev=0)"

echo "--- $TAG ---"

if [ ! -d "$DIST_DIR" ]; then mkdir "$DIST_DIR"; fi

set -- "Release" "Debug" "RelWithDebInfo" "MinSizeRel"

for BUILD_TYPE in "$@"
do
  BUILD_DIR="$(pwd)/build-$BUILD_TYPE"

  if [ -d "$BUILD_DIR" ]; then rm -Rf "$BUILD_DIR"; fi &&
    echo "--- $BUILD_TYPE ---" &&
    echo "--- Removing old bundles ---" && find "$DIST_DIR" -maxdepth 1 -name "$TAG*$BUILD_TYPE.zip" -print0 | xargs -0 rm -f &&
    mkdir "$BUILD_DIR" &&
    echo "--- Configuring CMake ---" && cmake -B "$BUILD_DIR" -DCMAKE_BUILD_TYPE=$BUILD_TYPE -DKURLIKOR_VERSION="$TAG" -DKURLIKOR_PACKAGE_SUFFIX=-$BUILD_TYPE &&
    echo "--- Building ---" && cmake --build "$BUILD_DIR" --config $BUILD_TYPE --parallel 8 &&
    cd "$BUILD_DIR" &&
    echo "--- Packing ---" && cpack -G ZIP -C $BUILD_TYPE --config ./kurlikorPackConfig.cmake &&
    echo "--- Coping bundles ---" && find . -maxdepth 1 -name "*$BUILD_TYPE.zip" -type f -print0 | xargs -0 -I {} cp {} "$DIST_DIR/" &&
    cd "$CUR_DIR" || exit
done
