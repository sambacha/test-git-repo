#!/bin/bash
SOURCE_DATE_EPOCH="$(gdate +%s)"
gtar --sort=name \
	--mtime="@${SOURCE_DATE_EPOCH}" \
	--owner=0 --group=0 --numeric-owner \
	--pax-option=exthdr.name=%d/PaxHeaders/%f,delete=atime,delete=ctime \
	-cf tarlockfile.tar package-lock.json
