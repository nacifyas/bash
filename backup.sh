#!/bin/bash
TARGET=$1
DEST=$2
DATE=$(date +%Y-%m-%d)
mkdir -p $DEST
NAME=$(basename $TARGET)-$DATE.tar.gz
echo "Running back up on $TARGET. Result will be stored at $DEST/$NAME"
systemd-inhibit --why="Back process on $TARGET" tar cvf - $TARGET | gzip -9 -> $DEST/$NAME
