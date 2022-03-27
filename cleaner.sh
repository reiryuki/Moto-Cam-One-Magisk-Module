PKG="com.motorola.motosignature.app
     com.motorola.cameraone"
for PKGS in $PKG; do
  rm -rf /data/user/*/$PKGS/cache/*
done

