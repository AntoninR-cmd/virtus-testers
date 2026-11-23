#!/usr/bin/env bash
# Virtus: runs in the app folder before the automatic Android build.
# The app's Gradle file reads android/key.properties unconditionally (release
# signing). It is rightly not in git, so give the debug build a placeholder.
if [ -d android ] && [ ! -f android/key.properties ] && grep -qs 'key.properties' android/app/build.gradle*; then
  printf 'storeFile=placeholder.jks\nstorePassword=placeholder\nkeyAlias=placeholder\nkeyPassword=placeholder\n' > android/key.properties
  echo "Placeholder android/key.properties written (debug build only)"
fi
