#!/bin/bash
PARENT=$1
CHILD=$2
if find -L "$PARENT" -samefile "$CHILD" -printf 'Y\n' -quit | grep -qF Y; 
then echo "contains '$child' or link thereto"
else echo NO
fi
