# ars-magica-grimoire

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
<spell type="general">
<name>Sample General Spell</name>
<level>GENERAL</level>
<arts><form>Animal</form><technique>Rego</technique></arts>
<range>Touch</range>
<duration>Ring</duration>
<target>Circle</target>
<description>
<p>Spells that are general have a type of general and the level says GENERAL.</p>
</description>
<guideline><base></base><modifiers></modifiers></guideline>
</spell>
```
  