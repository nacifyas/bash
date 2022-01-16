#!/bin/bash

algorithm () {
	TARGET=$1
	docker-compose -f "$TARGET" pull &&
        docker-compose -f "$TARGET" up -d
}

main () {
	echo "Retrieving docker-compose files"
	declare -a routes=(/home/nacifyas/dockerfile/*/*.yaml)
	for TARGET in "${routes[@]}";
	do (
		algorithm "$TARGET"
	); done
}

main
