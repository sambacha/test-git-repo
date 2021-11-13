#!/bin/sh

set -e

PACKAGE_JSON="package.json"
PACKAGE_JSON_NEW="package.new.json"
PACKAGE_LOCK="package-lock.json" # default. when shrinkwrap used, is npm-shrinkwrap.json

function usage() {
	echo "Usage: ${0} -d=<abs-path-to-dir-with-package.json> [-lf=<name-of-the-lock-file>]"
	echo "Output: Creates ${PACKAGE_JSON_NEW} in the same directory"
}

function check_reqs() {
	jq --help >/dev/null 2>&1 || {
		echo "jq not installed. Aborting." >&2
		exit 1
	}
	[ -d ${DIRECTORY} ] || {
		echo "Directory ${DIRECTORY} does not exist. Aborting"
		exit 1
	}
	[ -f ${DIRECTORY}/${PACKAGE_JSON} ] || {
		echo "${DIRECTORY}/${PACKAGE_JSON} not found. Aborting"
		exit 1
	}
	[ -f ${DIRECTORY}/${PACKAGE_LOCK} ] || {
		echo "${DIRECTORY}/${PACKAGE_LOCK} not found. Aborting"
		exit 1
	}
}

function get_locked_version() {
	jq ".dependencies.${1}.version" ${PACKAGE_LOCK} | sed 's/file://g'
}

function set_locked_version() {
	local cmd=".$1.$2=$3"
	echo $cmd
	jq --arg pkg "$2" --arg ver "$3" ${cmd} ${PACKAGE_JSON_NEW} >${PACKAGE_JSON_NEW}.1 &&
		mv ${PACKAGE_JSON_NEW}.1 ${PACKAGE_JSON_NEW}
}

function set_all_locked_versions() {
	for pkg in $(jq ".${1}" ${PACKAGE_JSON} | jq keys[]); do
		set_locked_version ${1} ${pkg} $(get_locked_version $pkg)
	done
}

function main() {
	cd ${DIRECTORY}
	cp ${PACKAGE_JSON} ${PACKAGE_JSON_NEW}
	set_all_locked_versions dependencies
	set_all_locked_versions devDependencies
	set_all_locked_versions peerDependencies
	echo "DONE! Created ${DIRECTORY}/${PACKAGE_JSON_NEW}"
}

for i in "$@"; do
	case $i in
	-d=* | --directory=*)
		DIRECTORY="${i#*=}"
		DIRECTORY=${DIRECTORY%/}
		if [[ "$DIRECTORY" != /* ]]; then
			# relative path
			DIRECTORY=$(pwd)/${DIRECTORY}
		fi
		shift
		;;
	-l=* | --lock-file=*)
		PACKAGE_LOCK="${i#*=}"
		shift
		;;
	-h | --help)
		usage
		exit 0
		;;
	esac
done

check_reqs
main
