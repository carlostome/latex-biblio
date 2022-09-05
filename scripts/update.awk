#!/bin/awk -f

BEGIN {
  if (ARGC != 3) {
    print "Usage: update.awk KEYFILE BIBFILE"
    exit 1
  }

  baseURL="https://dblp.org/rec"
  #keyFile=ARGV[1] # "dblp.keys"
  bibFile=ARGV[2] # "dblp.bib"

  ARGC=2 # consider only ARGV[1] as input file

  FS="," # separate download key from entry key (if any) by comma
}

{ # download key (see URL)
  key=$1
}

NF == 1 { # entry key defaults to last path segment of DBLP:**/* (see renameEntry)
  name="\\2"
  printf "Downloading " key "... "
}

NF == 2 { # entry key given explicitly
  name=$2
  printf "Downloading " key " as " name "... "
}

{
  renameEntry="s/DBLP:([[:alnum:]]*\\/)*([[:alnum:]-]*)/" name "/"
  deleteEmpty="/^$/d"
  sedCmd="sed -r -e '" renameEntry "' -e '" deleteEmpty "'"

  URL=baseURL "/" key ".bib"
  wgetCmd="wget --quiet -O - " URL

  cmdLine=wgetCmd " | " sedCmd " >> " bibFile
  cmdLine | getline
  close(cmdLine)
  print "."
}
