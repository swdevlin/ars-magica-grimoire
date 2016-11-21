@echo off
set template=formsummary.xsl
set print=
set source=ars_spells.xml
set paper=letter
set orientation=portrait

:parse
IF "%~1"=="" GOTO endparse
IF "%~1"=="-s" set source=%~2
IF "%~1"=="-t" set template=%~2
IF "%~1"=="-p" set print=true
IF "%~1"=="-paper" set paper=%~2
IF "%~1"=="-orientation" set orientation=%~2
IF "%~1"=="/?" goto help
IF "%~1"=="-?" goto help
SHIFT
GOTO parse
:endparse

java -cp c:\winutil\saxon\saxon9he.jar net.sf.saxon.Transform -t -s:"%source%" -xsl:"%template%" -o:ars_spells.fo edit=%print% cover=%cover% paper=%paper% orientation=%orientation% source=%spellsource%
c:\WinUtil\fop\fop -fo ars_spells.fo -pdf form_summary.pdf -c fop.cfg
exit /B

:help
ECHO Create Ars Magica Grimoire PDF
ECHO. 
ECHO Convert an XML file of spells to a PDF. The grimoire will include a preface, guidelines, and the spell list. The PDF will be named ars_magica_grimoide.pdf.
ECHO.
ECHO If you want a grimoire without guidelines, use the spellsonly.bat command.
ECHO ibtbook.bat [-c] [-w] [-o] [-p] [-s filename] [-t filename]
ECHO -c   Suppress the cover page
ECHO -p   Generate a PDF suitable for printing; no background images
ECHO -s   Specify the source XML file; the default filename is ars_spells.xml
ECHO -t   Specify a template to use; by default the script will determine the XSL file to use based on the command line options
ECHO -paper        letter (default), A4, or tabloid
ECHO -orientation  portait (defatult), or landscape
exit /B