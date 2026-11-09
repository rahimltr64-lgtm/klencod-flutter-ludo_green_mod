#!/usr/bin/env bash
# Re-sign base.apk + all splits with ONE key and bundle them (needs Android build-tools: apksigner, and Java).
# Usage: ./sign_and_make_apks.sh
set -e
KS=my.keystore
[ -f $KS ] || keytool -genkeypair -keystore $KS -storepass android -keypass android -alias key -keyalg RSA -keysize 2048 -validity 10000 -dname "CN=Ludo Mod"
mkdir -p signed
for f in base.apk split_config.*.apk; do
  apksigner sign --ks $KS --ks-pass pass:android --key-pass pass:android --out signed/$f $f
done
(cd signed && zip -q ../Ludo_Classic_green.apks *.apk)
echo "Done: Ludo_Classic_green.apks  (install with SAI app, or: adb install-multiple signed/*.apk)"
echo "Uninstall the original Ludo Classic first (signature differs)."
