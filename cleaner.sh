MODPATH=${0%/*}
APP="`ls $MODPATH/system/priv-app` `ls $MODPATH/system/app`"
for APPS in $APP; do
  rm -f `find /data/dalvik-cache /data/resource-cache -type f -name *$APPS*.apk`
done
PKG="com.motorola.motosignature.app
     com.motorola.cameraone"
for PKGS in $PKG; do
  rm -rf /data/user/*/$PKGS/cache/*
done


