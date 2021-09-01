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

FETCHBIB=$(mktemp -u)
FETCHBIBNORMAL=$(mktemp)
BIBFILENORMAL=$(mktemp)

sh ${SCRIPTDIR}/update.sh $FETCHBIB $KEYFILE

BIBER='biber --tool --nolog -q -q'

$BIBER -O $FETCHBIBNORMAL $FETCHBIB || true # XXX: Ignore Warning: XML::LibXML compiled against libxml2 20912, but runtime libxml2 is older 20910
$BIBER -O $BIBFILENORMAL  $BIBFILE  || true

diff -u --label $BIBFILE $BIBFILENORMAL --label $KEYFILE $FETCHBIBNORMAL && echo "$BIBFILE and $KEYFILE seem to contain the same entries."

rm $FETCHBIB $FETCHBIBNORMAL $BIBFILENORMAL
