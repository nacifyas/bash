#!/bin/bash
TARGET=$1
DEST=$2
DATE=$(date +%Y-%m-%d)
mkdir -p $DEST
PARENT=$TARGET
CHILD=$DEST
if find -L "$PARENT" -samefile "$CHILD" -printf 'Y\n' -quit | grep -qF Y;
then echo "error: The backup cannot be generated to the same folder, nor any of its subdirectories"
else
NAME=$(basename $TARGET)-$DATE.tar.gz
echo "Running back up on $TARGET. Result will be stored at $DEST/$NAME"
systemd-inhibit --why="Back process on $TARGET" tar cvf - $TARGET | gzip -9 -> $DEST/$NAME
fi
