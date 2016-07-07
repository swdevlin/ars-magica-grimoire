<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:java="http://xml.apache.org/xslt/java"
  exclude-result-prefixes="java" xmlns:fo="http://www.w3.org/1999/XSL/Format">

  <xsl:param name="single" select="''"/>
  <xsl:param name="edit" select="''"/>
  <xsl:param name="spellsonly" select="'false'"/>

  <xsl:output method="xml" indent="yes" />
  
  <xsl:variable name="in" select="/" />
  <xsl:variable name="sortedspells">
    <xsl:for-each select="$in/ars_magica/spells/spell">
      <xsl:sort select="name"/>
      <xsl:copy-of select="current()"/>
    </xsl:for-each>
  </xsl:variable>
  
  <xsl:variable name="handcolour">#2B1B09</xsl:variable>
  <xsl:variable name="Creo">#FFFFF0</xsl:variable> <!-- white --> 
  <xsl:variable name="Intellego">#FFD700</xsl:variable> <!-- gold -->
  <xsl:variable name="Muto">#F0E68C</xsl:variable> <!-- constantly fluctuating -->
  <xsl:variable name="Perdo">#000000</xsl:variable> <!-- black -->
  <xsl:variable name="Rego">#800080</xsl:variable> <!-- purple -->
  <xsl:variable name="Animal">#8B4513</xsl:variable> <!-- brown -->
  <xsl:variable name="Aquam">#000080</xsl:variable> <!-- blue -->
  <xsl:variable name="Auram">#EE82EE</xsl:variable> <!-- violet -->
  <xsl:variable name="Corpus">#8B0000</xsl:variable> <!-- dark red -->
  <xsl:variable name="Herbam">#006400</xsl:variable> <!-- green -->
  <xsl:variable name="Imaginem">#ADD8E6</xsl:variable> <!-- pearly blue -->
  <xsl:variable name="Ignem">#DC143C</xsl:variable> <!-- bright red -->
  <xsl:variable name="Mentem">#FF8C000</xsl:variable> <!-- orange -->
  <xsl:variable name="Terram">#583933</xsl:variable> <!-- dark brown -->
  <xsl:variable name="Vim">#C0C0C0</xsl:variable> <!-- silver --> 
  <xsl:variable name="artfont">Lombardy MC</xsl:variable>
  <xsl:variable name="handfont">Asphyxiate</xsl:variable>
  <xsl:variable name="sigfont">Asphyxiate</xsl:variable>
  <xsl:variable name="textfont">Calibri</xsl:variable>

  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="$single = ''"><xsl:call-template name="book"/></xsl:when>
      <xsl:otherwise><xsl:call-template name="singleform"/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="book">
    <fo:root>
      <fo:layout-master-set>
        <fo:simple-page-master master-name="spell-list" page-width="11in" page-height="8.5in" margin="0cm">
          <fo:region-body column-count="3" margin-bottom="0.5in"  margin-top="0.5in" margin-left="2cm" margin-right="2cm"/>
          <fo:region-before region-name="xsl-region-before" extent=".5in" />
          <fo:region-after region-name="xsl-region-after" extent=".5in" margin-right="2cm"/>
        </fo:simple-page-master>
        
      </fo:layout-master-set>

      <!--  Each form/technique pair  -->
      <xsl:for-each select="/ars_magica/arts/form/name">
        <xsl:variable name="form" select="."/>
        <xsl:for-each select="/ars_magica/arts/technique/name">
          <xsl:variable name="technique" select="."/>
          <xsl:call-template name="spellblock">
            <xsl:with-param name="form" select="$form"/>
            <xsl:with-param name="technique" select="$technique"/>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:for-each>
      <xsl:call-template name="spellindex"></xsl:call-template>
    </fo:root>
  </xsl:template>
  
  <xsl:template name="singleform">
    <fo:root>
      <fo:layout-master-set>
        <fo:simple-page-master master-name="spell-list" page-width="11in" page-height="8.5in" margin="0cm">
          <fo:region-body column-count="2" margin-bottom="0.5in"  margin-top="0.5in" margin-left="2cm" margin-right="2cm"/>
          <fo:region-before region-name="xsl-region-before" extent=".8in" />
          <fo:region-after region-name="xsl-region-after" extent=".25in" />
        </fo:simple-page-master>
      </fo:layout-master-set>
    
      <xsl:for-each select="/ars_magica/arts/technique/name">
        <xsl:variable name="technique" select="."/>
        <xsl:call-template name="spellblock">
          <xsl:with-param name="form" select="$single"/>
          <xsl:with-param name="technique" select="$technique"/>
        </xsl:call-template>
      </xsl:for-each>
    </fo:root>
  </xsl:template>

  <xsl:template name="spellblock">
    <xsl:param name="form"/>
    <xsl:param name="technique"/>
    <fo:page-sequence master-reference="spell-list">
      <fo:static-content flow-name="xsl-region-before">
        <xsl:if test="$edit = ''">
          <fo:block-container absolute-position="absolute" top="0cm" left="0cm" height="8.5in" width="11.8in"
            background-image="images/{$form}-paper-wide.jpg">
            <fo:block />
          </fo:block-container>
        </xsl:if>
        <fo:block></fo:block>
      </fo:static-content>
      <fo:static-content flow-name="xsl-region-after">
        <fo:block color="{$handcolour}" text-align-last="justify" font-family="{$textfont}" font-size="8pt" font-weight="normal" margin-left="2cm" margin-right="2cm">
          <fo:page-number/><fo:leader leader-pattern="space" /><xsl:value-of select="$technique"/><xsl:text> </xsl:text><xsl:value-of select="$form"/>
        </fo:block>
      </fo:static-content>
      <fo:flow flow-name="xsl-region-body">
        <xsl:variable name="color"><xsl:value-of select="/ars_magica/arts/form[name=$form]/color"/></xsl:variable>
        <fo:block color="{$color}" text-transform="capitalize"
          font-family="{$artfont}" font-size="12pt" margin-bottom="8px" font-weight="normal"><xsl:value-of select="$technique"/><xsl:text> </xsl:text><xsl:value-of select="$form"/> Spells</fo:block>
            <xsl:variable name="generalspells" select="$in/ars_magica/spells/spell[arts/technique=$technique and arts/form=$form and level='GENERAL']"/>
            <xsl:variable name="spells" select="$in/ars_magica/spells/spell[arts/technique=$technique and arts/form=$form and level != 'GENERAL']"/>
        <xsl:variable name="levels" select="distinct-values($spells/level)"/>

        <xsl:if test="count($generalspells) &gt; 0">
          <fo:block keep-with-next.within-page="always" font-size="9pt" font-family="{$textfont}" margin-bottom="0.2em">GENERAL</fo:block>
          <xsl:call-template name="spells-at-level">
            <xsl:with-param name="form" select="$form"/>
            <xsl:with-param name="technique" select="$technique"/>
            <xsl:with-param name="level" select="'GENERAL'"/>
          </xsl:call-template>
        </xsl:if>
        <xsl:for-each select="$levels">
            <xsl:sort select="." data-type="number"/>
          <xsl:variable name="slevel" select="."/>
          <fo:block keep-with-next.within-page="always" font-size="9pt" font-family="{$textfont}" margin-bottom="0.2em">LEVEL <xsl:value-of select="$slevel"/></fo:block>
          <xsl:call-template name="spells-at-level">
            <xsl:with-param name="form" select="$form"/>
            <xsl:with-param name="technique" select="$technique"/>
            <xsl:with-param name="level" select="$slevel"/>
          </xsl:call-template>
        </xsl:for-each>
      </fo:flow>
    </fo:page-sequence>
  </xsl:template>

  <xsl:template name="spells-at-level">
    <xsl:param name="form"/>
    <xsl:param name="technique"/>
    <xsl:param name="level"/>
    <xsl:for-each select="$sortedspells/spell[arts/technique=$technique and arts/form=$form and level=$level]">
      <fo:block page-break-inside="avoid">
        <fo:block id="{generate-id(.)}" font-family="{$textfont}" font-size="9pt" font-weight="normal">
          <fo:inline text-transform="capitalize"><xsl:value-of select="name" /></fo:inline><xsl:call-template name="source"/>
        </fo:block>
        <fo:block font-family="{$textfont}" text-indent="1em" font-size="8pt" font-weight="normal">
          R: <xsl:apply-templates select="range" />, D: <xsl:apply-templates select="duration" />, T: <xsl:value-of select="target" />
          <xsl:if test="@type='mystery'">, Mystery</xsl:if>
          <xsl:if test="@ritual='true'">, Ritual</xsl:if>
          <xsl:if test="@faerie='true'">, Faerie</xsl:if>
          <xsl:if test="@atlantean='true'">, Atlantean</xsl:if>
        </fo:block>
        <xsl:if test="count(arts/requisite) &gt; 0">
          <fo:block font-family="{$textfont}" text-indent="1em" font-size="8pt">Requisite: <xsl:apply-templates select="arts/requisite"><xsl:sort select="."/></xsl:apply-templates></fo:block>
        </xsl:if>
        <xsl:apply-templates select="description"/>
        <fo:block margin-bottom="2mm" font-family="{$textfont}"
          font-size="7pt" font-style="italic" font-weight="normal">
          <xsl:choose>
            <xsl:when test="@type = 'standard' or @type = 'mystery'">
              <xsl:choose>
                <xsl:when test="guideline/@ward = 'true'">(As ward guideline)</xsl:when>
                <xsl:otherwise>(Base <xsl:value-of select="guideline/base" /> <xsl:call-template name="spell-guidelines" />
                <xsl:apply-templates select="arts/requisite" mode="guideline"/>)</xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:when test="@type = 'general'">(Base effect)</xsl:when>
            <xsl:when test="@type = 'unique'">(Unique spell)</xsl:when>
            <xsl:when test="@type = 'mercurian'">(Mercurian Ritual)</xsl:when>
            <xsl:when test="@type = 'special'">(Special spell)</xsl:when>
            <xsl:otherwise>
              ERROR
            </xsl:otherwise>
          </xsl:choose>
        </fo:block>
      </fo:block>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="spellindex">
    <fo:page-sequence master-reference="spell-list">
      <fo:static-content flow-name="xsl-region-before">
        <xsl:if test="$edit = ''">
          <fo:block-container absolute-position="absolute" top="0cm" left="0cm" height="8.5in" width="11.8in"
            background-image="images/index-paper-wide.jpg">
            <fo:block />
          </fo:block-container>
        </xsl:if>
        <fo:block>
          <fo:inline-container vertical-align="top" inline-progression-dimension="49.9%">
            <fo:block></fo:block>
          </fo:inline-container>
          <fo:inline-container vertical-align="top" inline-progression-dimension="49.9%">
            <fo:block></fo:block>
          </fo:inline-container>
        </fo:block>
      </fo:static-content>
      <fo:static-content flow-name="xsl-region-after">
        <fo:block color="{$handcolour}" text-align-last="justify" font-family="{$textfont}" font-size="8pt" font-weight="normal" margin-left="2cm" margin-right="2cm">
          <fo:page-number/><fo:leader leader-pattern="space" /> 
        </fo:block>
      </fo:static-content>
      <fo:flow flow-name="xsl-region-body">
        <xsl:for-each select="$sortedspells/spell">
          <xsl:variable name="first" select="substring(name,1,1)"/>
          <xsl:variable name="prev" select="preceding-sibling::*[1]"/>
          <xsl:variable name="name" select="name"/>

          <xsl:if test="not(substring($prev/name, 1, 1)=$first)">
            <fo:block keep-with-next.within-page="always" font-family="{$artfont}" font-size="12pt" font-weight="normal" margin-top="0.5em">
              <xsl:value-of select="$first"/>
            </fo:block>
          </xsl:if>
          <fo:block font-family="{$textfont}" font-size="8pt" font-weight="normal" text-align-last="justify">
            <fo:basic-link internal-destination="{generate-id(.)}">
              <xsl:value-of select="name" />
              <fo:leader leader-pattern="dots" />
              <fo:page-number-citation ref-id="{generate-id(.)}" />              
            </fo:basic-link>
          </fo:block>
        </xsl:for-each>
      </fo:flow>
    </fo:page-sequence>
  </xsl:template>

  <xsl:include href="file:./core.xsl"/>
 
</xsl:stylesheet>