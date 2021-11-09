#!/bin/bash
echo *.txt ident > .gitattributes
echo this is a test $Id$ > test1.txt
git hash-object --no-filters test1.txt
