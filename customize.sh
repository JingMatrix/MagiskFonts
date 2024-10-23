#! sh

if [ -z $MAGISK_VER ]; then
	echo "If you see this in the installation process, please cancel it."
	ui_print() { echo "$@" 1>&2; }
	set_perm_recursive() { return; }
	MODPATH=$PWD
fi

font_dir="/product"
font_config_file="$font_dir/etc/fonts_customization.xml"
config_end_mark="fonts-modification"

ui_print "Pull original $font_config_file"
mkdir -p $MODPATH/$font_dir/etc
sed "/^<!-- <\/$config_end_mark> -->/q" $font_config_file >$MODPATH/$font_config_file
sed -i '$ d' $MODPATH/$font_config_file
echo "<!-- </$config_end_mark> -->" >>$MODPATH/$font_config_file

set_perm_recursive $MODPATH/tool root root 700 700

ui_print "Injecting custom fonts"
cd $MODPATH/$font_dir/fonts/
fscan() {
	FONTCONFIG_PATH=$MODPATH/tool LD_LIBRARY_PATH=$MODPATH/tool $MODPATH/tool/fc-scan "$@"
}
for fontfile in *.*; do
	ui_print "Add custom fonts $fontfile"
	fscan -f '  <family customizationType="new-named-family" name="%{family[0]|downcase}">\n    <font postScriptName="%{postscriptname}" weight="400" style="normal">%{file}</font>\n  </family>\n\n' \
		"$fontfile" >>$MODPATH/$font_config_file
	fscan -f "%{family}" "$fontfile" | grep ',' >/dev/null
	if [ $? -eq 0 ]; then
		fscan -f '  <alias name="%{family[1]}" to="%{family[0]|downcase}" />\n\n'\
			"$fontfile" >>$MODPATH/$font_config_file
	fi
done
cd /

echo "</fonts-modification>" >>$MODPATH/$font_config_file
ui_print "New $font_config_file generated"
