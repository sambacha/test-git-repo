#!/usr/bin/env bash
set -Eeuo pipefail

printf -v beg '%(%s)T\n' -2
sleep 1
printf -v now '%(%s)T\n' -1

echo beg=$beg now=$now elapsed=$((now - beg))
