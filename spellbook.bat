REM java -cp c:\winutil\saxon\saxon9he.jar net.sf.saxon.Transform -t -s:ars_spells.xml -xsl:spellbook2.xsl -o:spellbook.fo
java -cp c:\winutil\saxon\saxon9he.jar net.sf.saxon.Transform -t -s:ars_spells.xml -xsl:spellbook3.xsl -o:spellbook.fo
c:\WinUtil\fop\fop -fo spellbook.fo -pdf spellbook.pdf -c fop.cfg
