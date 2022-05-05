#!/bin/bash
TZ=UTC git show --quiet --date="format-local:%Y.%-m.%-d" --format="nightly-%cd" >nightly-release.txt
