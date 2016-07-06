# Ars Magica Grimoire

A system for producing PDFs of Ars Magica spells. This started as a project for producing a single PDF of all published spells for Ars Magica.

## Requirements

You will need to install Java.

You will need to install [Saxon](http://saxon.sourceforge.net/) to convert the spell XML document to an XSL:FO document.

And, lastly, you will need to install [fop](https://xmlgraphics.apache.org/fop/) to produce the PDF from the XSL:FO document.

Once installed, edit the boot.bat file, setting the path to Saxon and fop to match your system setup.

## How to run

Just run the spellbook.bat file. It will create the XSL:FO and then produce the PDF.

## XML Definition

### Spell Schema

Add your spells to the ars_spells.xml file.

```xml
<spell type="general" ritual="true" faerie="true" atlantean="true">
<name>Sample General Spell</name>
<level>GENERAL</level>
<arts><form>Animal</form><technique>Rego</technique><requisite free="true" notes="about the requiste">Muto</requisite></arts>
<range>Touch</range>
<duration>Ring</duration>
<target>Circle</target>
<description>
<p>Spells that are general have a type of general and the level says GENERAL.</p>
<flavour>Not really about the spell, more about the world.</flavour>
</description>
<guideline><base></base><modifiers><modifier>+1 additional strength</modifier><modifier>+1 living and non-living objects</modifier></modifiers></guideline>
</spell>
```
The *Type* attribute can be standard, general, unique, mercurian, or special.

The ritual, faerie, and atlantean attributes are all optional. If set to true, then that label is displayed on the spell details line.

`level` is either the spell level or `GENERAL` if it is a general spell. The level is not calculated, you must enter the final spell level.

The `<arts>` tag can contain 0 or more `<requisite>` tags. The free attribute is optional, and defaults to false. If the notes attribute is included then that text is added to the guideline text for the requisite in the text below the spell.

`range`, `duration`, and `target` must be spelled out in full; you cannot use `conc` for `Concentration`, for example.

`description` holds one or more `p` and `flavour` tags. `flavour` text is printed in italics.

`guidelines` holds the spell guideline notes. `base` is the level of the base guideline for the spell. There is no need to include the range, duration, and target level modifiers, the XSL will do that for you. You only need to list non-standard level modifiers.

## Credits

Base texture from [Kerstin Frank](https://www.flickr.com/photos/kerstinfrank-design/6257550414/in/photostream/)
