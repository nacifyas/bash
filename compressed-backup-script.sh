#!/bin/bash

displayHelp() {
    echo "This is the documentation"
}

FLAG_SUBDIR=false
FLAG_ECO=false
while getopts :edh opt; do
    case "$opt" in
        e) FLAG_ECO=true ;;
        d) FLAG_SUBDIR=true ;;
        h) displayHelp; exit;;
        :) echo "Missing argument for option -$OPTARG"; exit 1;;
       \?) echo "Unknown option -$OPTARG"; exit 1;;
    esac
done
shift $(( OPTIND - 1 ))
TARGET=$1
DEST=$2

# Creates a given directory if it does not exit
 dirExists () {
    DIR=$1
    if [ -d "$DIR" ]
        then
        echo "Destination $DIR exist"
        return 0
    else
        mkdir -p "$DIR"
        echo "Created destination directory at $DIR"
        return 1
    fi
}

# Performs the backup using tar archive and compresses on the run using gzip at its best compression
 algorithm () {
    TARGET_PATH=$1
    DEST_PATH=$2/$(basename "$1")
    NAME=$(basename "$1")-$(date +"%d_%m_%Y_%I_%M_%p").tar.gz
    mkdir -p "$DEST_PATH"
    if $FLAG_ECO;
        then echo "Flag -e detected. Deleting old backups before creating, to save space on the disk"
        rm -rf "${DEST_PATH}"/*
    fi
    echo "Running back up on $TARGET_PATH. Result will be stored at $DEST_PATH"
    tar cvf - "$TARGET_PATH" | gzip -9 -> "$DEST_PATH"/"$NAME"
}

 main () {
    PARENT=$1
    CHILD=$2
    DIR_STATE=$(dirExists "$CHILD")
    if find -L "$PARENT" -samefile "$CHILD" -printf 'Y\n' -quit | grep -qF Y;
        then
        echo "error: The backup cannot be generated within the targeted folder, nor within any of its subdirectories"
        if [ "$DIR_STATE" = 1 ];
            then rm -r "$CHILD"
        fi
        exit 1
    else
        echo "Paths are valid"
        if "$FLAG_SUBDIR";
            then
            echo "Detected -d flag activated. Running backup for each directory in $TARGET instead"
            for D in "$TARGET"/*;
            do (
	        algorithm "$TARGET"/"$(basename $D)" "$DEST"
            ); done
        else algorithm "$TARGET" "$DEST"
        fi
    fi
}

main "$TARGET" "$DEST"

