# Magisk

This module configures fonts that you add for system-wise usage.

## Usage

1. Clone this repository: `git clone ---depth 1 https://github.com/JingMatrix/MagiskFonts`;
2. Create a directory `system/fonts`: `mkdir -p system/fonts`;
3. Put your fonts inside `system/fonts`, currently `ttf` files work well;
4. Pack and install the zip module: `7z a MagiskFonts.zip META-INF customize.sh module.prop system tool`.

## Why do I need it?

Add fonts for applications like browsers and e-books readers, such as `Google Play Books`.
