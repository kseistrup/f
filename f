#!/usr/bin/env bash

# f - easily select a range of fields separated by blanks
#
# Motivation:
#  · cut(1) operates on a single field separator only
#  · awk(1) will not let you select a range of fields
#
# Copyright ©2020 Klaus Alexander Seistrup <klaus@seistrup.dk>
# License: GNU General Public License v3+ ⌘ http://gplv3.fsf.org/
# Issues ⌘ https://github.com/kseistrup/f

ME="${0##*/}"
RANGE="${1:-0}"

set -euo pipefail

usage () {
  cat << __EOT__
Usage: f [OPTIONS] [FIELDS]

OPTIONS are:
  -h, --help	print this help text and exit

FIELDS can have one of the following forms:
  N		Nth field, counted from 1
  N-		from Nth to last (included) field
  N-M		from Nth to Mth (included) field
   -M		from first to Mth (included) field
  nf		synonym for the last field

E.g.:
  \$ echo 1 2 3 4 5 | $ME 3
  3
  \$ echo 1 2 3 4 5 | $ME 2-4
  2 3 4
  \$ echo 1 2 3 4 5 | $ME nf
  5

If no FIELDS are given, lines are printed verbatim.
__EOT__
}

case "$RANGE" in
  -h | --help | -help )
    usage
    exit 0
  ;;
  *-* )
    OLDIFS="$IFS"; IFS='-'
    read -r FIRST LAST <<< "$RANGE"
    IFS="$OLDIFS"
    test -z "$FIRST" && FIRST=1
    test -z "$LAST"  && LAST=NF
    exec awk "
      BEGIN {
        OFS=\"\"
	ORS=\"\"
      } {
        last = NF > $LAST ? $LAST : NF

        for (i = $FIRST; i < last; i++)
	  print \$i \" \"

	if (last > $FIRST)
	  print \$last \"\\n\"
      }
    "
  ;;
  '' ) FIELD=0 ;;
  nf ) FIELD=NF ;;
   * ) FIELD="$RANGE" ;;
esac
exec awk "{ print \$$FIELD }"
# eof
