#! sh

if [ -z $MAGISK_VER ]; then
	echo "If you see this in the installation process, please cancel it."
	ui_print() { echo "$@" 1>&2; }
	set_perm_recursive() { return; }
	MODPATH=$PWD
fi

ui_print "Pull original fonts.xml"
mkdir -p $MODPATH/system/etc
head -n -1 $(magisk --path)/.magisk/mirror/system/etc/fonts.xml >$MODPATH/system/etc/fonts.xml

set_perm_recursive $MODPATH/tool root root 700 700

ui_print "Injecting custom fonts"
cd $MODPATH/system/fonts/
fscan() {
	FONTCONFIG_PATH=$MODPATH/tool LD_LIBRARY_PATH=$MODPATH/tool $MODPATH/tool/fc-scan "$@"
}
for fontfile in *.*; do
	ui_print "Add custom fonts $fontfile"
	fscan -f '\t<family name="%{family[0]|downcase}">\n\t\t<font postScriptName="%{postscriptname}">%{file}</font>\n\t</family>\n' \
		"$fontfile" >>$MODPATH/system/etc/fonts.xml
	fscan -f "%{family}" "$fontfile" | grep ',' >/dev/null
	if [ $? -eq 0 ]; then
		fscan -f '\t<alias name="%{family[1]}" to="%{family[0]|downcase}" />\n'\
			"$fontfile" >>$MODPATH/system/etc/fonts.xml
	fi
done
cd /

echo "</familyset>" >>$MODPATH/system/etc/fonts.xml
ui_print "New fonts.xml generated"
