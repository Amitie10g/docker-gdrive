#!/bin/sh

set -ex

PUID=${PUID:-0}
PGID=${PGID:-0}

# Functions
setup(){
  echo "Initialising google-drive-ocamlfuse..."
  echo "$VERIFICATION_CODE"
  google-drive-ocamlfuse \
    -label "$LABEL" \
    -f \
    -cc \
    -skiptrash \
    -headless \
    -id "$CLIENT_ID.apps.googleusercontent.com" \
    -secret "$CLIENT_SECRET" \

}

mount() {
  echo "Mounting at $DRIVE_PATH..."
  google-drive-ocamlfuse "$DRIVE_PATH" \
    -o "noatime,uid=$PUID,gid=$PGID,allow_other" \
    -label "$LABEL" \
    -f \
    -cc \
    -skiptrash \
    -headless \

}

if [ -e "$HOME/.gdfuse/${LABEL}/config" ]; then
  echo "Notice: No Google Drive configuration found."
else
  if [ -z "$CLIENT_ID" ]; then
    echo "Fatal: no CLIENT_ID found -> EXIT"
    exit 1
  elif [ -z "$CLIENT_SECRET" ]; then
    echo "Fatal: no CLIENT_SECRET found -> EXIT"
    exit 1
  elif [ -z "$VERIFICATION_CODE" ]; then
    echo "Warning: no VERIFICATION_CODE found"
    setup
    exit 1
  else
    setup
  fi
fi

mount
