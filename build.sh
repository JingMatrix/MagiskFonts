#! bash

pushd fontconfig
rm -rf build
meson build
ninja -C build
cp build/fc-scan/fc-scan build/src/libfontconfig.so* ../tool
echo '<fontconfig></fontconfig>' > tool/fonts.conf
popd
rm -rf system/etc
rm -rf MagiskFonts.zip
7z a MagiskFonts.zip META-INF customize.sh module.prop system tool
