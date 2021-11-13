#!/bin/bash -ex
: ${SRC_DIR:=/data/src}
: ${HTML_DIR:=/public}
: ${BIN_DIR:=/data/bin}

FQDN=
GITHUB_ORG=
REPO=

#if ! test -d $SRC_DIR/.git; then
#
#fi
git clone https://github.com/$GITHUB_ORG/$REPO $SRC_DIR

(
	cd $SRC_DIR
	git restore .
	git pull --ff-only
	git show -s --format=%ct HEAD >$HTML_DIR/commit-ts.txt
	# well known

	cat >$HTML_DIR/.well-known/$REPO.xml <<EOF
<entry>
  <version>$(date +%Y-%m-%d)-$(git rev-parse HEAD)</version>
  <url>https://$FQDN/.well-known/$REPO.tgz</url>
</entry>
EOF
	# Binaries
	echo *.txt ident >.gitattributes
	echo commits $Id$ >githash.txt
	git hash-object --no-filters githash.txt

	#$REPO_REPRODUCIBLE=dev ./tools/buildall.sh . $BIN_DIR HEAD

)
$(dirname $0)/update-index
