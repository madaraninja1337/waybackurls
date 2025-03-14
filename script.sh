#!/usr/bin/env bash
while getopts f:d:p: o;do
 case "$o" in
  f)F="$OPTARG";;
  d)D="$OPTARG";;
  p)P="$OPTARG";;
 esac
done

[ -n "$D" -a -z "$F" -a -z "$P" ]&&curl -s "http://web.archive.org/cdx/search/cdx?url=*.$D/*&collapse=urlkey&showNumPages=true"&&exit 0

[ -z "$F" -o -z "$D" -o -z "$P" ]&&echo "Uso: $0 -f <arquivo> -d <dominio> -p <pagina>"&&exit 1

curl -s "http://web.archive.org/cdx/search/cdx?url=*.$D/*&output=txt&fl=original&limit=10000&page=$P" -o "$F"
