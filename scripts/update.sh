#!/bin/sh

usage() {
  echo "Usage: $(basename $0) [-h] [-f] [BIBFILE] [KEYFILE]"
}

usage_and_exit_zero() {
  usage
  exit 0
}

usage_and_exit_nonzero() {
  usage
  exit 2
}

scriptDir=$(dirname $0)

#baseURL=https://dblp.org/rec
keyFile=${scriptDir}/dblp.keys
bibFile=${scriptDir}/../dblp.bib

#sed -r 's/$$/.bib/' $keyFile | wget -i - -nc --base=$baseURL -O $bibFile
#sed -ri 's/DBLP:[[:alnum:]]*\/[[:alnum:]]*\/([[:alnum:]-]*)/\1/' $bibFile

overwrite=
while getopts hf name
do
  case $name in
  h) usage_and_exit_zero;;
  f) overwrite=1;;
  ?) usage_and_exit_nonzero;;
  esac
done
shift $(($OPTIND - 1))

if [ $# -gt 0 ]
then
  bibFile=$1
  shift
fi

if [ $# -gt 0 ]
then
  keyFile=$1
  shift
fi

[ $# -gt 0 ] && usage_and_exit_nonzero

if [ ! -r $keyFile ]
then
  echo "Input file \`$keyFile' not readable... abort."
  exit 1
fi

if [ -f $bibFile -a ! -z "$overwrite" ]
then
  rm $bibFile || exit $?
fi

if [ -f $bibFile ]
then
  echo "Output file \`$bibFile' exists... abort. (overwrite with option \`-f')"
  exit 1
fi

awk -f $(dirname $0)/update.awk $keyFile $bibFile
