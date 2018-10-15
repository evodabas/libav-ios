#!/bin/bash

set -e
cd $(dirname "${BASH_SOURCE[0]}")

SDK_VERSION="$(xcodebuild -showsdks | grep iphoneos | cut -d ' ' -f 2)"
if [ "$SDK_VERSION" == "" ]; then
	echo "iOS SDK Not Found"
	exit
fi

# install gas-preprocessor
mkdir -p build/bin
cp gas-preprocessor.pl build/bin/gas-preprocessor.pl
cd build/bin
export PATH="$(pwd):$PATH"
cd ../../

# ################################################

mkdir -p build/arm64/install && cd build/arm64
../../configure \
--cc=`xcrun -f --sdk iphoneos${SDK_VERSION} clang` \
--arch=aarch64 \
--cpu=generic \
--sysroot=`xcrun --sdk iphoneos${SDK_VERSION} --show-sdk-path` \
--target-os=darwin \
--extra-cflags='-arch arm64' \
--extra-ldflags='-arch arm64 -miphoneos-version-min=7.0' \
--enable-cross-compile \
--disable-programs

make -j6 && make install DESTDIR=install
cd ../../

# ################################################

mkdir -p build/x86_64/install && cd build/x86_64
../../configure \
--arch=x86_64 \
--cpu=generic \
--sysroot=`xcrun --sdk iphonesimulator${SDK_VERSION} --show-sdk-path` \
--target-os=darwin \
--extra-cflags='-arch x86_64' \
--extra-ldflags='-arch x86_64 -miphoneos-version-min=7.0' \
--enable-cross-compile \
--disable-programs

make -j6 && make install DESTDIR=install
cd ../../

# ################################################

cd build

libs=( libavcodec libavfilter libavresample libswscale libavdevice libavformat libavutil )
for lib in "${libs[@]}"; do
	echo "frameworks/${lib}.framework/${lib}"
	mkdir -p "frameworks/${lib}.framework"
	lipo -create \
	-arch arm64 "arm64/install/usr/local/lib/${lib}.a" \
	-arch x86_64 "x86_64/install/usr/local/lib/${lib}.a" \
	-output "frameworks/${lib}.framework/${lib}"
	mkdir -p "frameworks/${lib}.framework/Headers/"
	cp arm64/install/usr/local/include/${lib}/* "frameworks/${lib}.framework/Headers/"
done



