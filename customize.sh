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
for fontfile in $MODPATH/system/fonts/*.*; do
	fontname=$(FONTCONFIG_PATH=$MODPATH/tool LD_LIBRARY_PATH=$MODPATH/tool $MODPATH/tool/fc-scan -f '%{postscriptname}' "$fontfile")
	ui_print "Add custom fonts $fontname"
	echo '	<family name="'$fontname'">' >>$MODPATH/system/etc/fonts.xml
	echo "		<font>$(basename fontfile)</font>" >>$MODPATH/system/etc/fonts.xml
	echo "	</family>" >>$MODPATH/system/etc/fonts.xml
done

echo "</familyset>" >>$MODPATH/system/etc/fonts.xml
ui_print "New fonts.xml generated"
