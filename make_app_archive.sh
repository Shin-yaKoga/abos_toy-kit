#!/bin/sh

if [ $# -lt 1 ]; then
	echo "Usage: make_app_archive.sh <app dir>"
	exit 1
fi

CWD="$PWD"
APP_DIR="$1"
cd "$APP_DIR"
tar cz $(cat app_file_list) -f "$CWD/app.tar.gz"

