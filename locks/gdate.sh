#!/bin/bash
date() {
	if [ "$1" = "-I" ]; then
		command date "+%Y-%m-%dT%H:%M:%S%z"
	else
		command date "$@"
	fi
}
