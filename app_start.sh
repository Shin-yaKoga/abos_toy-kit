#!/bin/sh

APP_NAME=$1
APP_ARCHIVE="/var/app/$APP_NAME/app.tar.gz"

if [ -n "$2" ]; then
	APP_ARCHIVE="$2"
fi

if [ -e "$APP_ARCHIVE" ]; then
	echo "application archive is $APP_ARCHIVE"
else
	echo "specified application archive $APP_ARCHIVE is not exist"
	exit 1
fi

podman_start --create "$APP_NAME"
if [ ! $? ]; then
	echo "failed to create the container: $APP_NAME"
	exit 1
fi

MOUNT_DIR="$(podman mount $APP_NAME)"
mkdir -p "$MOUNT_DIR"/var/app
tar xf "$APP_ARCHIVE" -C "$MOUNT_DIR"/var/app
podman umount $APP_NAME
podman start $APP_NAME
