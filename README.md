# Ars Magica Grimoire

A system for producing PDFs of Ars Magica spells.
PDFs can be in letter, A4, or tabloid page size, and either portrait or landscape.
PDFs can be produced with page grounds for viewing on-line, or with no background for printing, although they
look pretty good printed if your printer supports full page printing.

This started as a project for producing a single PDF of all published spells for Ars Magica.

## History

2016-12-03
* Flavour text now renders sub elements correctly
* Added support for the `<self/>` tag, which renders as the name of the current spell, in italics.

## Example

Andrew Breese, of [Iron-Bound Tome](https://ironboundtome.wordpress.com/), has 
been kind enough to use his excellent Ars Magica spell collection as a test
collection for this project. An XML document with his spells, plus a sample PDF file,
are in the examples\ibt folder.

## Requirements

You will need to install Java.

You will need to install [Saxon](http://saxon.sourceforge.net/) to convert the spell XML document to an XSL:FO document.

You will need to install [fop](https://xmlgraphics.apache.org/fop/) to produce the PDF from the XSL:FO document.

The font used for external URL links can be downloaded from: http://ftp.gnome.org/pub/GNOME/sources/ttf-bitstream-vera/1.10/

Once installed, edit the boot.bat file, setting the path to Saxon and fop to match your system setup.

## How to run

### Windows

There are two batch files.

spellbook.bat will produce a grimoire PDF with a preface, guidelines, and spells, along with a spell index. It supports the following options:

*-c* do not print the cover (preface) page
*-s* specify the source spell XML document; the default is ars_spells.xml
*-t* specify the XSL file to use; the default is spellbook.xsl
*-p* produce a PDF for printing; no page backgrounds will be used
*-nospellsource* the source of spells or guidelines will not be displayed
*-paper* specify the paper size, either letter, A4, or tabloid. The default is letter
*-orientation* specify page orientation, either portait or landscapel default is portait
*/?* display help
*-?* display help

spellsonly.bat will produce a grimoire PDF with a preface, spells, and a spell index. It supports the following options:

*-c* do not print the cover (preface) page
*-s* specify the source spell XML document; the default is ars_spells.xml
*-t* specify the XSL file to use; the default is spellsonly.xsl
*-p* produce a PDF for printing; no page backgrounds will be used
*-f* flow one form/technique pair after another; by default, each pair starts on its own page
*-nospellsource* the source of spells or guidelines will not be displayed
*-paper* specify the paper size, either letter, A4, or tabloid. The default is letter
*-orientation* specify page orientation, either portait or landscapel default is portait
*/?* display help
*-?* display help

## XML Definition

### Preface

You can include a preface for your grimiore. This will be printed at the begining of the document, on its own page or pages if you are particularly wordy. The preface has its own page background.

```xml
<preface>
  <p indent="false" font="hand" size="24pt" colour="hand">Most Learned Companion,</p>
  <p font="hand" size="18pt" colour="hand">
    Contained here-in are all of the known enchantments of Fractured Magic, recorded without prejudice or bias. 
    Many sources, both illustrious and wondrous, were exhaustively studied to author the compendium you now hold in your venerable hands. 
    Enumeration of all prestigious references consulted in the transcription of these enchantments would require a tome as mighty as this one. 
    I would be amiss, though, not to mention references that were more valuable than most: <booklist/>.
  </p>
  <p indent="false" font="hand" size="48pt" colour="#661A1A">N'Allette</p>
</preface>
```

Use the `p` tag for each new paragraph. The first line of the paragraph will be indented unless `indent` is set to false. You can control the typeface, size, and colour of the text with the `font`, `size`, and `colour` attributes respectively. You can use the shortcut of `hand` for font and colour to use the default in the XSL. The default size is 8pt.

The `booklist` tag will insert a list of books included in the document as well as the number of spells from each book. It is optional.

### Booklist

You can include a list of reference material used to compile your grimoire.

```xml
<books>
  <book><abbreviation>C</abbreviation><name>Covenants</name></book>
  <book><abbreviation>App</abbreviation><name>Apprentices</name></book>
  <book><abbreviation>AM</abbreviation><name>Ancient Magic</name></book>
</books>
```

`abbreviation` maps to the `source` tag in the spell definition. `name` is used when listing books in the preface using the `booklist` tag.

### Arts

You can include notes about each form and technique.

```xml
<arts>
  <form>
    <name>Animal</name>
    <color>#8B4513</color>
    <description>
      <p>Description about the form.</p>
      <p>Multiple paragraphs are allowed.</p>
    </description>
  </form>
  ...
  <technique>
    <name>Creo</name>
    <color>#FFFFF0</color>
  </technique>
  ...
</arts>
```

The system uses the list of forms to generate the pages. So even if you have no notes, you should keep an entry for each form. `p` denotes a paragraph.

The notes for each form are printed on their own page and use the background associated with the form.

The techniques are used when selecting spells to print.

### Guidelines

The system supports printing guidelines for each form/technique pair. Each pair prints on its own page and uses the form's backdrop.

```xml
<arts_guidelines>
  <arts_guideline>
    <arts><form>Animal</form><technique>Creo</technique></arts>
    <description>
      <p>Standard description section.</p>
      <p>Multiple paragraphs are allowed. You are also able to use <spell-link name="Name of the spell"/> tags.</p>
    </description>
    <guidelines>
      <guideline source="RoP:M" page="27"><level>General</level><description>A description of a General guideline.</description></guideline>
      <guideline><level>1</level><description>Description of a guideline with a level.</description></guideline>
    </guidelines>
  </arts_guideline>
  ...
</arts_guidelines>
```

The `description` section prints before the list of guidelines, same as in the core Ars Magica book.

`guideline`s are printed in the order listed; you will need to do the sorting manually.

You can include a `source` and `page` attribute for a guideline. They will print at the end of the guideline.

### Spell Schema

Add your spells to the ars_spells.xml file.

```xml
<spell source="C" page="12" type="general" ritual="true" faerie="true" atlantean="true">
  <name>Sample General Spell</name>
  <level>GENERAL</level>
  <arts>
    <form>Animal</form>
    <technique>Rego</technique>
    <requisite free="true" notes="about the requiste">Muto</requisite>
  </arts>
  <range>Touch</range>
  <duration>Ring</duration>
  <target>Circle</target>
  <description>
  <p>Spells that are general have a type of general and the level says GENERAL. You can also reference another spell using <spell-link name="Name of the Other Spell"/>.</p>
  <flavour>Not really about the spell, more about the world.</flavour>
  </description>
  <guideline>
    <base></base>
    <modifiers>
      <modifier>+1 additional strength</modifier>
      <modifier>+1 living and non-living objects</modifier>
    </modifiers>
  </guideline>
</spell>
```

If `source` and `page` are included they are printed at the end of the name of the spell. The XSL supports a parameter to suppress the printing of the source.

The `type` attribute can be standard, general, unique, mercurian, or special.

The `ritual`, `faerie`, and `atlantean` attributes are optional. If set to true, then that label is displayed on the spell details line.

`level` is either the spell level or GENERAL if it is a general spell. The level is not calculated, you must enter the final spell level.

The `<arts>` tag can contain 0 or more `<requisite>` tags. The free attribute is optional, and defaults to false. If the `note` attribute is included then that text is added to the guideline text for the requisite in the text below the spell.

`<range>`, `<duration>`, and `<target>` must be spelled out in full, capitalized; you have to use `Concentration`, not `conc`, for example.

`<description>` holds one or more `<p>` and `<flavour>` tags. `<flavour>` text is printed in italics. If you use a spell-link tag, the XSL will convert that to a link and include the page number; useful for both on-line and print documents.

`<guidelines>` holds the spell guideline notes. `<base>` is the level of the base guideline for the spell. There is no need to include the range, duration, and target level modifiers, the XSL will do that for you. You only need to list non-standard level modifiers.

## Credits

Base texture for the page background is from [Kerstin Frank](https://www.flickr.com/photos/kerstinfrank-design/6257550414/in/photostream/)
