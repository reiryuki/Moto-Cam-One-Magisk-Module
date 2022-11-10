mount -o rw,remount /data
MODPATH=${0%/*}

# debug
exec 2>$MODPATH/debug-pfsd.log
set -x

# run
FILE=$MODPATH/sepolicy.sh
if [ -f $FILE ]; then
  . $FILE
fi

# conflict
rm -f /data/adb/modules/*/system/app/MotoSignatureApp/.replace

# cleaning
FILE=$MODPATH/cleaner.sh
if [ -f $FILE ]; then
  . $FILE
  rm -f $FILE
fi


