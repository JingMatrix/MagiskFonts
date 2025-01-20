# Magisk

This module configures fonts that you add for system-wise usage.

## Usage

1. Clone this repository: `git clone --depth=1 https://github.com/JingMatrix/MagiskFonts`;
2. Create a directory `system/fonts`: `mkdir -p system/fonts`;
3. Put your fonts inside `system/fonts`, currently `ttf` files work well;
4. Pack and install the zip module: `7z a MagiskFonts.zip META-INF customize.sh module.prop system tool`.

## Why do I need it?

Add fonts for applications like browsers and e-books readers, such as `Google Play Books`.

For problems of rendering fonts in browsers on Android 15+, please refer to [this issue](https://github.com/JingMatrix/FontLoader/issues/1).

## Reference

Parser location in [Android Code Search](https://cs.android.com/): [frameworks/base/graphics/java/android/graphics/FontListParser.java](https://cs.android.com/android/platform/superproject/main/+/main:frameworks/base/graphics/java/android/graphics/FontListParser.java).
