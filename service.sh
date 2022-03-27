(

MODPATH=${0%/*}
API=`getprop ro.build.version.sdk`

# debug
exec 2>$MODPATH/debug.log
set -x

# wait
sleep 60

# function
grant_permission() {
  UID=`pm list packages -U | grep $PKG | sed -n -e "s/package:$PKG uid://p"`
  pm grant $PKG android.permission.READ_EXTERNAL_STORAGE
  pm grant $PKG android.permission.WRITE_EXTERNAL_STORAGE
  pm grant $PKG android.permission.ACCESS_MEDIA_LOCATION
  appops set --uid $UID LEGACY_STORAGE allow
  appops set $PKG READ_EXTERNAL_STORAGE allow
  appops set $PKG WRITE_EXTERNAL_STORAGE allow
  appops set $PKG ACCESS_MEDIA_LOCATION allow
  appops set $PKG READ_MEDIA_AUDIO allow
  appops set $PKG READ_MEDIA_VIDEO allow
  appops set $PKG READ_MEDIA_IMAGES allow
  appops set $PKG WRITE_MEDIA_AUDIO allow
  appops set $PKG WRITE_MEDIA_VIDEO allow
  appops set $PKG WRITE_MEDIA_IMAGES allow
  if [ "$API" -gt 29 ]; then
    appops set $PKG MANAGE_EXTERNAL_STORAGE allow
    appops set $PKG NO_ISOLATED_STORAGE allow
    appops set $PKG AUTO_REVOKE_PERMISSIONS_IF_UNUSED ignore
  fi
}

# grant
PKG=com.motorola.cameraone
pm grant $PKG android.permission.CAMERA
pm grant $PKG android.permission.RECORD_AUDIO
pm grant $PKG android.permission.READ_PHONE_STATE
grant_permission

# grant
PKG=com.google.android.apps.photos
if pm list packages | grep -Eq $PKG; then
  grant_permission
fi

) 2>/dev/null


