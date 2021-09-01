#!/bin/sh

usage() { echo "Usage: $(basename $0) [-h] [BIBFILE] [KEYFILE]"; }

usage_and_exit_zero() { usage; exit 0; }

usage_and_exit_nonzero() { usage; exit 2; }

SCRIPTNAME=$(basename $0)
SCRIPTDIR=$(dirname $0)
KEYFILE=${SCRIPTDIR}/dblp.keys
BIBFILE=${SCRIPTDIR}/../dblp.bib

while getopts h name
do
  case $name in
  h) usage_and_exit_zero;;
  ?) usage_and_exit_nonzero;;
  esac
done
shift $(($OPTIND - 1))

[ $# -gt 0 ] && { BIBFILE=$1; shift; }

[ $# -gt 0 ] && { KEYFILE=$1; shift; }

[ $# -gt 0 ] && usage_and_exit_nonzero

[ -r $KEYFILE ] || { echo "${SCRIPTNAME}: $KEYFILE: No such file or permission denied"; exit 1; }

[ -r $BIBFILE ] || { echo "${SCRIPTNAME}: $BIBFILE: No such file or permission denied"; exit 1; }

FETCHKEYS=$(mktemp)
BIBKEYS=$(mktemp)

sed -ne 's/^[[:space:]]*@.*{\([[:alnum:]]*\).*$/\1/p'                   $BIBFILE | sort -u > $BIBKEYS
sed -ne 's/^[[:space:]]*\(.*[/,]\)\?\([[:alnum:]]*\)[[:space:]]*$/\2/p' $KEYFILE | sort -u > $FETCHKEYS

diff -u --label $BIBFILE $BIBKEYS --label $KEYFILE $FETCHKEYS && echo "$BIBFILE and $KEYFILE seem to contain the same keys."

rm $FETCHKEYS $BIBKEYS
