MODPATH=${0%/*}
API=`getprop ro.build.version.sdk`

# debug
exec 2>$MODPATH/debug.log
set -x

# wait
until [ "`getprop sys.boot_completed`" == "1" ]; do
  sleep 10
done

# function
grant_permission() {
UID=`pm list packages -U | grep $PKG | sed "s/package:$PKG uid://"`
pm grant $PKG android.permission.READ_EXTERNAL_STORAGE
pm grant $PKG android.permission.WRITE_EXTERNAL_STORAGE
if [ "$API" -ge 29 ]; then
  pm grant $PKG android.permission.ACCESS_MEDIA_LOCATION 2>/dev/null
  appops set $PKG ACCESS_MEDIA_LOCATION allow
  appops set --uid $UID ACCESS_MEDIA_LOCATION allow
fi
if [ "$API" -ge 33 ]; then
  pm grant $PKG android.permission.READ_MEDIA_AUDIO
  pm grant $PKG android.permission.READ_MEDIA_VIDEO
  pm grant $PKG android.permission.READ_MEDIA_IMAGES
  pm grant $PKG android.permission.POST_NOTIFICATIONS
  appops set $PKG ACCESS_RESTRICTED_SETTINGS allow
fi
appops set --uid $UID LEGACY_STORAGE allow
appops set $PKG LEGACY_STORAGE allow
appops set $PKG READ_EXTERNAL_STORAGE allow
appops set $PKG WRITE_EXTERNAL_STORAGE allow
appops set $PKG READ_MEDIA_AUDIO allow
appops set $PKG READ_MEDIA_VIDEO allow
appops set $PKG READ_MEDIA_IMAGES allow
appops set $PKG WRITE_MEDIA_AUDIO allow
appops set $PKG WRITE_MEDIA_VIDEO allow
appops set $PKG WRITE_MEDIA_IMAGES allow
if [ "$API" -ge 30 ]; then
  appops set $PKG MANAGE_EXTERNAL_STORAGE allow
  appops set $PKG NO_ISOLATED_STORAGE allow
  appops set $PKG AUTO_REVOKE_PERMISSIONS_IF_UNUSED ignore
fi
if [ "$API" -ge 31 ]; then
  appops set $PKG MANAGE_MEDIA allow
fi
}

# grant
PKG=com.motorola.cameraone
grant_permission
pm grant $PKG android.permission.CAMERA
pm grant $PKG android.permission.RECORD_AUDIO
APP=MotoCamOne
NAME=android.permission.WRITE_EXTERNAL_STORAGE
if ! dumpsys package $PKG | grep "$NAME: granted=true"; then
  FILE=`find $MODPATH/system -type f -name $APP.apk`
  pm install -g -i com.android.vending $FILE
  pm uninstall -k $PKG
  pm revoke $PKG android.permission.ACCESS_BACKGROUND_LOCATION
  pm revoke $PKG android.permission.ACCESS_COARSE_LOCATION
  pm revoke $PKG android.permission.ACCESS_FINE_LOCATION
  pm revoke $PKG android.permission.GET_ACCOUNTS
  pm revoke $PKG android.permission.READ_PHONE_STATE
fi

# grant
PKG=com.google.android.apps.photos
if pm list packages | grep $PKG; then
  grant_permission
fi


