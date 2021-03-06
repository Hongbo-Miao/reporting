#!/bin/bash

shopt -q nullglob
NULLGLOB_WAS_SET=$?
shopt -s nullglob
FILES=$(echo *.bs)
if [ 1 -eq $NULLGLOB_WAS_SET ]; then
  shopt -u nullglob
fi

set -e # Exit with nonzero exit code if anything fails

echo Running bikeshed on index.src.html
bikeshed -f spec ./index.src.html

for SPEC in $FILES; do
  echo Running bikeshed on $SPEC
  bikeshed -f spec $SPEC
done

OUTDIR=${1:-out}

if [ -d $OUTDIR ]; then
  echo Copy index.html into $OUTDIR/index.html
  cp index.html $OUTDIR/index.html
  for SPEC in $FILES; do
    SPEC_OUT=${SPEC%.bs}.html
    if [ -f $SPEC_OUT ]; then
      echo Copy $SPEC_OUT into $OUTDIR/$SPEC_OUT
      cp $SPEC_OUT $OUTDIR/$SPEC_OUT
    fi
  done
fi
