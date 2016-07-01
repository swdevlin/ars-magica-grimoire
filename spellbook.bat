java -cp c:\winutil\saxon\saxon9he.jar net.sf.saxon.Transform -t -s:ars_spells.xml -xsl:spellbook.xsl -o:spellbook.fo
c:\WinUtil\fop\fop -fo spellbook.fo -pdf spellbook.pdf -c fop.cfg
