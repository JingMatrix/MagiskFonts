#! sh

if [ -z $MAGISK_VER ]; then
	echo "If you see this in the installation process, please cancel it."
	ui_print() { echo "$@" 1>&2; }
	set_perm_recursive() { return; }
	MODPATH=$PWD
fi

set_perm_recursive $MODPATH/tool root root 700 700
fscan() {
	FONTCONFIG_PATH=$MODPATH/tool LD_LIBRARY_PATH=$MODPATH/tool $MODPATH/tool/fc-scan "$@"
}

generate_config() {

	if [ ! -f $font_config_file ]; then
		return 0
	fi

	ui_print "Pull original $font_config_file"
	mkdir -p $MODPATH/$font_dir/etc
	sed "/^<!-- <\/$config_end_mark> -->/q" $font_config_file >$MODPATH/$font_config_file
	sed -i '$ d' $MODPATH/$font_config_file
	echo "<!-- </$config_end_mark> -->" >>$MODPATH/$font_config_file

	font_family_config=$sep'<family customizationType="new-named-family" name="%{family[0]|downcase}">\n'$sep$sep'<font postScriptName="%{postscriptname}" weight="400" style="normal">%{file}</font>\n'$sep'</family>\n'
	alia_config=$sep'<alias name="%{family[1]}" to="%{family[0]|downcase}" />\n'

	cd $MODPATH/$font_dir/fonts/
	for fontfile in *.*; do
		ui_print "Add custom font $fontfile"
		fscan -f "$font_family_config" "$fontfile" >>$MODPATH/$font_config_file
		fscan -f "%{family}" "$fontfile" | grep ',' >/dev/null
		if [ $? -eq 0 ]; then
			fscan -f "$alia_config" "$fontfile" >>$MODPATH/$font_config_file
		fi
	done
	cd /

	echo "</$config_end_mark>" >>$MODPATH/$font_config_file
	ui_print "New $font_config_file generated"
	ui_print ""
}

ui_print "Module directory is $MODPATH"

font_dir="/system"
font_config_file="$font_dir/etc/fonts.xml"
config_end_mark="familyset"
sep="\t"
generate_config

font_dir="/system"
font_config_file="$font_dir/etc/font_fallback.xml"
config_end_mark="familyset"
sep="\t"
generate_config

