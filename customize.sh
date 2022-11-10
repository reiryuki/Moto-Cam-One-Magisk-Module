# boot mode
if [ "$BOOTMODE" != true ]; then
  abort "- Please flash via Magisk Manager only!"
fi

# space
if [ "$BOOTMODE" == true ]; then
  ui_print " "
fi

# magisk
if [ -d /sbin/.magisk ]; then
  MAGISKTMP=/sbin/.magisk
else
  MAGISKTMP=`realpath /dev/*/.magisk`
fi

# path
if [ "$BOOTMODE" == true ]; then
  MIRROR=$MAGISKTMP/mirror
else
  MIRROR=
fi
SYSTEM=`realpath $MIRROR/system`
PRODUCT=`realpath $MIRROR/product`
VENDOR=`realpath $MIRROR/vendor`
SYSTEM_EXT=`realpath $MIRROR/system/system_ext`
ODM=`realpath /odm`
MY_PRODUCT=`realpath /my_product`

# optionals
OPTIONALS=/sdcard/optionals.prop

# info
MODVER=`grep_prop version $MODPATH/module.prop`
MODVERCODE=`grep_prop versionCode $MODPATH/module.prop`
ui_print " ID=$MODID"
ui_print " Version=$MODVER"
ui_print " VersionCode=$MODVERCODE"
ui_print " MagiskVersion=$MAGISK_VER"
ui_print " MagiskVersionCode=$MAGISK_VER_CODE"
ui_print " "

# sdk
NUM=23
if [ "$API" -lt $NUM ]; then
  ui_print "! Unsupported SDK $API. You have to upgrade your"
  ui_print "  Android version at least SDK API $NUM to use this module."
  abort
else
  ui_print "- SDK $API"
  ui_print " "
fi

# opengles
PROP=`getprop ro.opengles.version`
if [ "$PROP" -lt 131072 ]; then
  ui_print "! Unsupported OpenGLES $PROP. This module is only"
  ui_print "  for OpenGLES 131072 and up."
  abort
else
  ui_print "- OpenGLES $PROP"
  ui_print " "
fi

# mount
if [ "$BOOTMODE" != true ]; then
  mount -o rw -t auto /dev/block/bootdevice/by-name/cust /vendor
  mount -o rw -t auto /dev/block/bootdevice/by-name/vendor /vendor
  mount -o rw -t auto /dev/block/bootdevice/by-name/persist /persist
  mount -o rw -t auto /dev/block/bootdevice/by-name/metadata /metadata
fi

# sepolicy.rule
FILE=$MODPATH/sepolicy.sh
DES=$MODPATH/sepolicy.rule
if [ -f $FILE ] && [ "`grep_prop sepolicy.sh $OPTIONALS`" != 1 ]; then
  mv -f $FILE $DES
  sed -i 's/magiskpolicy --live "//g' $DES
  sed -i 's/"//g' $DES
fi

# cleaning
ui_print "- Cleaning..."
PKG="com.motorola.motosignature.app
     com.motorola.cameraone"
if [ "$BOOTMODE" == true ]; then
  for PKGS in $PKG; do
    RES=`pm uninstall $PKGS`
  done
fi
rm -rf /metadata/magisk/$MODID
rm -rf /mnt/vendor/persist/magisk/$MODID
rm -rf /persist/magisk/$MODID
rm -rf /data/unencrypted/magisk/$MODID
rm -rf /cache/magisk/$MODID
ui_print " "

# function
permissive_2() {
sed -i '1i\
SELINUX=`getenforce`\
if [ "$SELINUX" == Enforcing ]; then\
  magiskpolicy --live "permissive *"\
fi\' $MODPATH/post-fs-data.sh
}
permissive() {
SELINUX=`getenforce`
if [ "$SELINUX" == Enforcing ]; then
  setenforce 0
  SELINUX=`getenforce`
  if [ "$SELINUX" == Enforcing ]; then
    ui_print "  Your device can't be turned to Permissive state."
    ui_print "  Using Magisk Permissive mode instead."
    permissive_2
  else
    setenforce 1
    sed -i '1i\
SELINUX=`getenforce`\
if [ "$SELINUX" == Enforcing ]; then\
  setenforce 0\
fi\' $MODPATH/post-fs-data.sh
  fi
fi
}

# permissive
if [ "`grep_prop permissive.mode $OPTIONALS`" == 1 ]; then
  ui_print "- Using device Permissive mode."
  rm -f $MODPATH/sepolicy.rule
  permissive
  ui_print " "
elif [ "`grep_prop permissive.mode $OPTIONALS`" == 2 ]; then
  ui_print "- Using Magisk Permissive mode."
  rm -f $MODPATH/sepolicy.rule
  permissive_2
  ui_print " "
fi

# function
hide_oat() {
for APPS in $APP; do
  mkdir -p `find $MODPATH/system -type d -name $APPS`/oat
  touch `find $MODPATH/system -type d -name $APPS`/oat/.replace
done
}

# hide
APP="`ls $MODPATH/system/priv-app` `ls $MODPATH/system/app`"
hide_oat

# function
extract_lib() {
for APPS in $APP; do
  ui_print "- Extracting..."
  FILE=`find $MODPATH/system -type f -name $APPS.apk`
  DIR=`find $MODPATH/system -type d -name $APPS`/lib/$ARCH
  mkdir -p $DIR
  rm -rf $TMPDIR/*
  unzip -d $TMPDIR -o $FILE $DES
  cp -f $TMPDIR/$DES $DIR
  ui_print " "
done
}

# extract
DES=lib/`getprop ro.product.cpu.abi`/*
extract_lib

# property
if [ "`grep_prop camera.prop $OPTIONALS`" == 1 ]; then
  ui_print "- Enables camera HAL 3, EIS, and OIS..."
  sed -i 's/#c//g' $MODPATH/system.prop
  ui_print " "
fi

# function
check_feature() {
if ! pm list features | grep -Eq $NAME; then
  ui_print "- Play Store data will be cleared automatically on"
  ui_print "  next reboot for app updates"
  echo 'rm -rf /data/user/*/com.android.vending/*' >> $MODPATH/cleaner.sh
  ui_print " "
fi
}
grant_permission() {
  if [ "$BOOTMODE" == true ]\
  && ! dumpsys package $PKG | grep -Eq "$NAME: granted=true"; then
    FILE=`find $MODPATH/system -type f -name $APP.apk`
    ui_print "- Granting all runtime permissions for $PKG..."
    RES=`pm install -g -i com.android.vending $FILE`
    pm grant $PKG $NAME
    if ! dumpsys package $PKG | grep -Eq "$NAME: granted=true"; then
      ui_print "  ! Failed."
      ui_print "  Maybe insufficient storage."
    fi
    RES=`pm uninstall -k $PKG`
    ui_print " "
  fi
}

# grant
APP=MotoCamOne
PKG=com.motorola.cameraone
NAME=android.permission.WRITE_EXTERNAL_STORAGE
grant_permission

# /priv-app
if [ ! -d $SYSTEM/priv-app ]; then
  ui_print "- /system/priv-app is not supported"
  ui_print "  Moving to /system/app..."
  rm -rf $MODPATH/system/app
  mv -f $MODPATH/system/priv-app $MODPATH/system/app
  ui_print " "
fi


