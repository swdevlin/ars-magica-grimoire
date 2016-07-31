@echo off
set template=spellsonly.xsl
set print=
set flow=
set source=ars_spells.xml
set cover=true
set spellsource=true
set paper=letter
set orientation=portrait

:parse
IF "%~1"=="" GOTO endparse
IF "%~1"=="-c" set cover=false
IF "%~1"=="-f" set flow=true
IF "%~1"=="-s" set source=%~2
IF "%~1"=="-p" set print=true
IF "%~1"=="-nospellsource" set spellsource=false
IF "%~1"=="-paper" set paper=%~2
IF "%~1"=="-orientation" set orientation=%~2
IF "%~1"=="/?" goto help
IF "%~1"=="-?" goto help
SHIFT
GOTO parse
:endparse

java -cp c:\winutil\saxon\saxon9he.jar net.sf.saxon.Transform -t -s:"%source%" -xsl:"%template%" -o:ars_spells.fo edit=%print% cover=%cover% flow=%flow% paper=%paper% orientation=%orientation% source=%spellsource%
c:\WinUtil\fop\fop -fo ars_spells.fo -pdf ars_magica_grimoire.pdf -c fop.cfg
exit /B

:help
ECHO Create Ars Magica Grimoire PDF
ECHO. 
ECHO Convert an XML file of spells to a PDF. The PDF will contain just the spells and an option preface.
ECHO. 
ECHO If you want a grimoire with guidelines, use the spellbook.bat command.
ECHO ibtbook.bat [-c] [-w] [-o] [-p] [-s filename] [-t filename]
ECHO -c            Suppress the cover page
ECHO -f            Do not start each form/technique on a new page
ECHO -p            Generate a PDF suitable for printing; no background images
ECHO -s            Specify the source XML file; the default filename is ars_spells.xml
ECHO -paper        letter (default), A4, or tabloid
ECHO -orientation  portait (defatult), or landscape
exit /B