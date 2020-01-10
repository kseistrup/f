# f

Easily select a range of fields separated by blanks

**Motivation:**

* `cut(1)` operates on a single field separator only
* `awk(1)` will not let you select a range of fields

```
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
  $ echo 1 2 3 4 5 | f 3
  3
  $ echo 1 2 3 4 5 | f 2-4
  2 3 4
  $ echo 1 2 3 4 5 | f nf
  5

If no FIELDS are given, lines are printed verbatim.
```
