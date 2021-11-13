#!/bin/bash
tar --sort=name \
	--mtime="@${SOURCE_DATE_EPOCH}" \
	--owner=0 --group=0 --numeric-owner \
	--pax-option=exthdr.name=%d/PaxHeaders/%f,delete=atime,delete=ctime \
	-cf lockfile.tar lockGitFile.nix
