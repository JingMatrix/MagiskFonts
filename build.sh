#! bash

[[ -e MagiskFonts.zip ]] && rm MagiskFonts.zip
if [[ -z $TERMUX_VERSION ]]; then
	echo "Skip building font-scan if not in termux"
	7z a MagiskFonts.zip META-INF customize.sh module.prop system tool
	exit
fi

pushd fontconfig
rm -rf build
meson build
ninja -C build
cp build/fc-scan/fc-scan build/src/libfontconfig.so* build/subprojects/freetype2/libfreetype.so* ../tool
popd
rm -rf product/etc
rm -rf system/etc
rm -rf MagiskFonts.zip
7z a MagiskFonts.zip META-INF customize.sh module.prop system tool
