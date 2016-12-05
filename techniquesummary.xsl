<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:java="http://xml.apache.org/xslt/java"
  exclude-result-prefixes="java" xmlns:fo="http://www.w3.org/1999/XSL/Format">

  <xsl:param name="edit" select="''"/>
  <xsl:param name="orientation" select="'portrait'"/>
  <xsl:param name="paper" select="'letter'"/>
  <xsl:param name="source" select="'true'"/>

  <xsl:output method="xml" indent="yes" />

  <xsl:include href="file:./pagesetup.xsl"/>
  
  <xsl:variable name="in" select="/" />

  <xsl:include href="file:./styles.xsl"/>

  <xsl:template match="/">
    <fo:root>
      <fo:layout-master-set>
        <fo:simple-page-master master-name="spell-list" page-height="{$height}" page-width="{$width}" margin="0cm">
<!--          <fo:region-body column-count="{$cols}" margin-bottom="0.5in"  margin-top="0.5in" margin-left="2cm" margin-right="2cm"/>-->
          <fo:region-body column-count="1" margin-bottom="0.5in" margin-top="0.5in" margin-left="2cm" margin-right="2cm"/>
          <fo:region-before region-name="xsl-region-before" extent=".5in"/>
          <fo:region-after region-name="xsl-region-after" extent=".5in" margin-right="2cm"/>
        </fo:simple-page-master>
      </fo:layout-master-set>
      <xsl:call-template name="spellsummary"/>
    </fo:root>
  </xsl:template>

  <xsl:template name="spellsummary">
    <fo:page-sequence master-reference="spell-list">
      <fo:static-content flow-name="xsl-region-before">
        <xsl:if test="$edit = ''">
          <fo:block-container absolute-position="absolute" top="0cm" left="0cm" width="{$width}" height="{$height}">
            <fo:block>
              <fo:external-graphic src="images/index-paper{$wide}.jpg" content-height="scale-to-fit" height="{$height}" content-width="{$width}" scaling="non-uniform"/>
            </fo:block>
          </fo:block-container>
        </xsl:if>
        <fo:block-container absolute-position="absolute" top="0.8cm" left="2cm" margin-right="1cm">
          <fo:block>
            <fo:table>
              <fo:table-body>
                <fo:table-row table-layout="fixed">
                  <fo:table-cell>
                    <fo:block font-weight="bold" font-size="8pt">Name</fo:block>
                  </fo:table-cell>    
                  <fo:table-cell width="4em">
                    <fo:block font-weight="bold" font-size="7pt">Technique</fo:block>
                  </fo:table-cell>
                  <fo:table-cell width="4em">
                    <fo:block font-weight="bold" font-size="7pt">Form</fo:block>
                  </fo:table-cell>
                  <fo:table-cell text-align="center" width="2.8em">
                    <fo:block font-weight="bold" font-size="7pt">Level</fo:block>
                  </fo:table-cell>
                  <fo:table-cell width="5em">
                    <fo:block font-weight="bold" font-size="7pt">Requisites</fo:block>
                  </fo:table-cell>
                  <fo:table-cell width="5em">
                    <fo:block font-weight="bold" font-size="7pt">Special</fo:block>
                  </fo:table-cell>
                  <fo:table-cell width="2.8em">
                    <fo:block font-weight="bold" font-size="7pt">Source</fo:block>
                  </fo:table-cell>
                  <fo:table-cell width="2.8em">
                    <fo:block font-weight="bold" font-size="7pt">Page</fo:block>
                  </fo:table-cell>
                </fo:table-row>
              </fo:table-body>
            </fo:table>
          </fo:block>
        </fo:block-container>
      </fo:static-content>
      <fo:static-content flow-name="xsl-region-after">
        <fo:block color="{$handcolour}" text-align-last="justify" font-family="{$textfont}" font-size="8pt" font-weight="normal" margin-left="2cm" margin-right="2cm">
          <fo:page-number/><fo:leader leader-pattern="space" /><fo:retrieve-marker retrieve-class-name="form"/>
        </fo:block>
      </fo:static-content>
      <fo:flow flow-name="xsl-region-body">
        <fo:table>
          <fo:table-body>
            <xsl:apply-templates select="$in/ars_magica/spells/spell[name != '']" mode="summarytable">
              <xsl:sort select="arts/technique"/>
              <xsl:sort select="arts/form"/>
              <xsl:sort select="level" data-type="number"/>
              <xsl:sort select="name"/>
            </xsl:apply-templates>
          </fo:table-body>
        </fo:table>
      </fo:flow>
    </fo:page-sequence>
  </xsl:template>

  <xsl:template match="spell" mode="summarytable">
    <fo:table-row table-layout="fixed">
      <fo:table-cell>
        <fo:block font-size="7.5pt"><xsl:value-of select="name"/></fo:block>
      </fo:table-cell>    
      <fo:table-cell width="4em">
        <fo:block font-size="7pt"><xsl:value-of select="arts/technique"/></fo:block>
      </fo:table-cell>
      <fo:table-cell width="4em">
        <fo:block font-size="7pt"><xsl:value-of select="arts/form"/></fo:block>
      </fo:table-cell>
      <fo:table-cell width="2.8em">
        <fo:block font-size="7pt"><xsl:choose><xsl:when test="level = 'GENERAL'">G</xsl:when><xsl:otherwise><xsl:value-of select="level"/></xsl:otherwise></xsl:choose></fo:block>
      </fo:table-cell>
      <fo:table-cell width="5em">
        <fo:block font-size="7pt"><xsl:apply-templates select="arts/requisite" mode="abbreviation"/></fo:block>
      </fo:table-cell>
      <fo:table-cell width="5em">
        <fo:block font-size="7pt">
          <xsl:if test="@type='mystery'">Mystery </xsl:if>
          <xsl:if test="@ritual='true'">Ritual </xsl:if>
          <xsl:if test="@faerie='true'">Faerie </xsl:if>
          <xsl:if test="@subtype != ''"><xsl:value-of select="@subtype"/> </xsl:if>
          <xsl:if test="@atlantean='true'">Atlantean </xsl:if>
        </fo:block>
      </fo:table-cell>
      <fo:table-cell width="2.8em">
        <fo:block font-size="7pt"><xsl:value-of select="@source"/></fo:block>
      </fo:table-cell>
      <fo:table-cell width="2.8em">
        <fo:block font-size="7pt"><xsl:value-of select="@page"/></fo:block>
      </fo:table-cell>
    </fo:table-row>
  </xsl:template>

  <xsl:template match="requisite" mode="abbreviation">
    <xsl:choose>
      <xsl:when test=". = 'Animal'">An</xsl:when>
      <xsl:when test=". = 'Corpus'">Co</xsl:when>
      <xsl:when test=". = 'Herbam'">He</xsl:when>
      <xsl:when test=". = 'Ignem'">Ig</xsl:when>
      <xsl:when test=". = 'Auram'">Au</xsl:when>
      <xsl:when test=". = 'Aquam'">Aq</xsl:when>
      <xsl:when test=". = 'Mentem'">Me</xsl:when>
      <xsl:when test=". = 'Imaginem'">Im</xsl:when>
      <xsl:when test=". = 'Terram'">Te</xsl:when>
      <xsl:when test=". = 'Vim'">Vi</xsl:when>

      <xsl:when test=". = 'Creo'">Cr</xsl:when>
      <xsl:when test=". = 'Muto'">Mu</xsl:when>
      <xsl:when test=". = 'Perdo'">Pe</xsl:when>
      <xsl:when test=". = 'Intellego'">In</xsl:when>
      <xsl:when test=". = 'Rego'">Re</xsl:when>
    </xsl:choose><xsl:if test="position() &lt; last()">, </xsl:if>
  </xsl:template>

</xsl:stylesheet>