#!/bin/bash
FLAG_SUBDIR=false
while getopts :hd opt; do
    case $opt in 
        h) show_some_help; exit ;;
        d) FLAG_SUBDIR=true ;;
        :) echo "Missing argument for option -$OPTARG"; exit 1;;
       \?) echo "Unknown option -$OPTARG"; exit 1;;
    esac
done
shift $(( OPTIND - 1 ))
TARGET=$1
DEST=$2
DATE=$(date +%Y-%m-%d)
mkdir -p $DEST
PARENT=$TARGET
CHILD=$DEST
if $FLAG_SUBDIR; then
	for d in $TARGET/*;
       		do (
			SUBDIR=$(basename $d)
		        if find -L "$PARENT" -samefile "$CHILD" -printf 'Y\n' -quit | grep -qF Y; then
		                echo "error: The backup cannot be generated to the same folder, nor any of its subdirectories"
       			 else
				 NAME=$(basename $d)-$DATE.tar.gz
               			 echo "Running back up on $TARGET/$SUBDIR. Result will be stored at $DEST/$NAME"
            			 systemd-inhibit --why="Back process on $TARGET/$SUBDIR" tar cvf - $TARGET/$SUBDIR/ | gzip -9 -> $DEST/$NAME
       			 fi
		); done
else
	if find -L "$PARENT" -samefile "$CHILD" -printf 'Y\n' -quit | grep -qF Y; then
      		echo "error: The backup cannot be generated to the same folder, nor any of its subdirectories"
	else
        	NAME=$(basename $TARGET)-$DATE.tar.gz
	        echo "Running back up on $TARGET. Result will be stored at $DEST/$NAME"
       		systemd-inhibit --why="Back process on $TARGET" tar cvf - $TARGET | gzip -9 -> $DEST/$NAME
	fi
fi
