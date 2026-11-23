#!/usr/bin/env bash
# Virtus: runs in the app folder before the automatic Android build.
# The app's Gradle file reads android/key.properties unconditionally (release
# signing). It is rightly not in git, so give the debug build a placeholder.
if [ -d android ] && [ ! -f android/key.properties ] && grep -qs 'key.properties' android/app/build.gradle*; then
  printf 'storeFile=placeholder.jks\nstorePassword=placeholder\nkeyAlias=placeholder\nkeyPassword=placeholder\n' > android/key.properties
  echo "Placeholder android/key.properties written (debug build only)"
fi
# The app gives Gradle 1.5 GB, too little for Jetifier on CI runners (16 GB): raise it to 4 GB
if [ -f android/gradle.properties ] && grep -q '^org.gradle.jvmargs=-Xmx1536M' android/gradle.properties; then
  sed -i 's/^org.gradle.jvmargs=.*/org.gradle.jvmargs=-Xmx4g -XX:MaxMetaspaceSize=1g/' android/gradle.properties
  echo "Gradle heap raised to 4 GB (CI only)"
fi
