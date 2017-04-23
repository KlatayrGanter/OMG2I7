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
cat 'inform.i7x' | perl I72OMG.pl "10-15" > 'omg.i7y'

#only affects OMG subroutines, starting with IMO.
cat 'omg.i7y' | perl OMG2I7.pl > 'back_to_inform.i7x'
```

Example (OMG):
```
IMO (areas disclosed - 4 cover areas) concealed by (garb - a garment) = 4 garments:

	$covering ~ cover areas 2 garments;
	$disclosed layer = body layer o garb;

	4 cloth @garments worn by the holder o garb:

		$current layer = body layer o cloth;
		If cloth = invisible / current layer = disclosed layer, next;

		4 part @cover areas o cloth:

			if cloth = ripped & part =@ rip areas o cloth, next;
			if cloth = shifted & part =@ shift areas o cloth, next;

			if covering ~ part 2 garment:
				$other cloth = garment o covering ~ part;
				if body layer o other cloth > current layer, next;
			ow:
				part -@ areas disclosed;

			BTW, covering ~ part 2 cloth;
	GA 4 garments o covering;
```
results in inform 7:

```inform
To decide which list of garments is (areas disclosed - a list of cover areas) concealed by (garb - a garment):
	Let covering be a various-to-one relation of the cover areas to garments;
	Let the disclosed layer be the body layer of the garb;
	Repeat with cloth running through the garments worn by the holder of the garb:
		Let the current layer be the body layer of the cloth;
		If cloth is invisible or the current layer is disclosed layer, next;
		Repeat with part running through the cover areas of the cloth:
			If cloth is ripped and the part is listed in the rip areas of the cloth, next;
			If cloth is shifted and the part is listed in the shift areas of the cloth, next;
			If part relates to garment by the covering:
				Let the other cloth be the garment to which the part relates by the covering;
				If body layer of the other cloth is greater than the current layer, next;
			Else:
				Remove the part from the areas disclosed, if present;
			Now the covering relates part to cloth;
	Decide on the list of the garments which the covering relates to;
```

