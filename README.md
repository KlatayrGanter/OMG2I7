# OMG2I7
sorta slang 2 inform 7 utility in pl

Problems:
* only a few inform 7 language features are supported currently
* this langage is unstable

contains scripts to convert inform 7 to an acronym & symbols language and back.
The slang also allows for whitespace in its subroutines.

Usage:

```sh
#if given the range argument only affects these lines, otherwise whole document.
cat 'inform.i7y' | perl I72OMG.pl "10-15" > 'inform.i7z'

#only affects OMG subroutines, starting with IMO.
cat 'test.i7x' | perl OMG2I7.pl > 'omg.i7y'
```

