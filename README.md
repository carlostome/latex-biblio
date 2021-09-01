# latex-biblio

This repository unifies bibliographic data (for use with
[biblatex](https://www.ctan.org/pkg/biblatex) and
[biber](https://ctan.org/pkg/biber)) from different sources such as
[dblp](https://dblp.org/),
[MathSciNet](https://mathscinet.ams.org/mathscinet) and others.

## Conventions

### Keys

1. Publication entries should be indexed by a key that consists of
   the surname of the first author, then the initials of the other
   surnames, and then the last two digits of the year of publication.

   For instance, a publication by Reynolds and Girard from 1987 should
   have the key `ReynoldsG87`.

2. Software entries should be indexed by the name.

   For instance, the software Agda should have the key `Agda`.

### File format

1. The type of entries should use lowercase letters, e.g., `@article`
   and *not* `@ARTICLE`.

2. The first two fields should be, in order, author and title.

3. Autor fields should be surnames, a comma, and given names.

   E.g., `P\'erez Gonz\'alez, Jos\'e Carlos` and *not* ` Jos\'e Carlos P\'erez Gonz\'alez`.

   Several authors are to be separated by `and` and appear on
   different lines.

4. Fields should be indented by two spaces and be aligned
   on the `=` symbol at column 16.

As a first step to comply with the format, one can use `biber --tool
--output-field-order=author,title --output-align
--output-fieldcase=lower`; however, more post-processing might be
needed.

## Sources

### dblp

The file `dblp.bib` contains the bibliography from dblp.
For computer science publications this is the preferred source.

dblp organizes its bibliographic data according to their own key
format which includes whether it is a conference or journal, its
name, and then the key, which usually, but not always, coincides
with the format in (see our conventions above).

#### How to add new entries?

The file `scripts/dblp.keys` contains the dblp keys of all the
entries that should go in `dblp.bib`.

The format consists of a list of dblp keys (ordered by first author)
and for those that don't adhere to the our conventions the corrected
key after a comma.

For example, to add a publication by Church from 1941 with dblp key
`journal/sl/abs-0001-002` we add `journal/sl/abs-0001-002,Church41`
to `dblp.keys` in the correct alphabetic position.

To update dblp.bib, we provide a script which can be run as follows
`./scripts/update.sh`.  This  downloads every publication entry for
the dblp keys in `dblp.keys`.

To compare `dblp.bib` and `dblp.keys`. 

- `scripts/cmpkeys.sh`: checks the dblp keys in `dblp.keys` against
  the entry keys in `dblp.bib`.

- `scripts/cmpentries.sh` checks that the entries in `dblp.bib`
  correspond to freshly downloaded entries from dblp.

### MathSciNet

TBD: Custom fields from MathSciNet are to be removed. Change the
entry key to adhere to our conventions.

### Others

For entries that are not present in dblp or MathSciNet, we keep a
file `local.bib` with custom entries. This file should follow our
conventions.
