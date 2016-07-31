<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:java="http://xml.apache.org/xslt/java"
  exclude-result-prefixes="java" xmlns:fo="http://www.w3.org/1999/XSL/Format">

  <xsl:param name="cover" select="'true'"/>
  <xsl:param name="single" select="''"/>
  <xsl:param name="edit" select="''"/>
  <xsl:param name="flow" select="''"/>
  <xsl:param name="orientation" select="'portrait'"/>
  <xsl:param name="paper" select="'letter'"/>
  <xsl:param name="source" select="'true'"/>

  <xsl:output method="xml" indent="yes" />

  <xsl:include href="file:./pagesetup.xsl"/>
  
  <xsl:variable name="in" select="/" />
  <xsl:variable name="sortedspells">
    <xsl:for-each select="$in/ars_magica/spells/spell">
      <xsl:sort select="name"/>
      <xsl:copy-of select="current()"/>
    </xsl:for-each>
  </xsl:variable>

  <xsl:include href="file:./styles.xsl"/>

  <xsl:template match="/">
    <fo:root>
      <fo:layout-master-set>
        <fo:simple-page-master master-name="spell-list" page-height="{$height}" page-width="{$width}" margin="0cm">
          <fo:region-body column-count="{$cols}" margin-bottom="0.5in"  margin-top="0.5in" margin-left="2cm" margin-right="2cm"/>
          <fo:region-before region-name="xsl-region-before" extent=".5in" />
          <fo:region-after region-name="xsl-region-after" extent=".5in" margin-right="2cm"/>
        </fo:simple-page-master>

        <fo:simple-page-master master-name="inner-leaf" page-height="{$height}" page-width="{$width}">
          <fo:region-body margin="2cm" margin-right="2cm" />
          <fo:region-before region-name="xsl-region-before" extent="3in"/>
          <fo:region-after region-name="xsl-region-after" extent=".25in" />
        </fo:simple-page-master>
      </fo:layout-master-set>
      
      <xsl:if test="$cover = 'true'">
        <fo:page-sequence master-reference="inner-leaf">
          <xsl:if test="$edit = ''">
            <fo:static-content flow-name="xsl-region-before">
              <fo:block-container absolute-position="absolute" top="0cm" left="0cm" width="{$width}" height="{$height}">
                <fo:block>
                  <fo:external-graphic src="images/leaflet{$wide}.jpg" content-height="scale-to-fit" height="{$height}" content-width="{$width}" scaling="non-uniform"/>
                </fo:block>
              <fo:block></fo:block>
              </fo:block-container>
            </fo:static-content>
          </xsl:if>
          <fo:static-content flow-name="xsl-region-after"><fo:block></fo:block></fo:static-content>
          <fo:flow flow-name="xsl-region-body">
            <xsl:apply-templates select="$in/ars_magica/preface" mode="preface"/>
         </fo:flow>
        </fo:page-sequence>
      </xsl:if>
      
      <xsl:choose>
        <xsl:when test="$flow = 'true'"><xsl:call-template name="spellflow"/></xsl:when>
        <xsl:otherwise><xsl:call-template name="spellsection"/></xsl:otherwise>
      </xsl:choose>
      <xsl:call-template name="spellindex"></xsl:call-template>
    </fo:root>
  </xsl:template>

  <xsl:template name="spellflow">
    <fo:page-sequence master-reference="spell-list">
      <fo:static-content flow-name="xsl-region-before">
        <xsl:if test="$edit = ''">
          <fo:block-container absolute-position="absolute" top="0cm" left="0cm" width="{$width}" height="{$height}">
            <fo:block>
              <fo:external-graphic src="images/index-paper{$wide}.jpg"  content-height="scale-to-fit" height="{$height}"  content-width="{$width}" scaling="non-uniform"/>
            </fo:block>
          </fo:block-container>
        </xsl:if>
        <fo:block></fo:block>
      </fo:static-content>
      <fo:static-content flow-name="xsl-region-after">
        <fo:block color="{$handcolour}" text-align-last="justify" font-family="{$textfont}" font-size="8pt" font-weight="normal" margin-left="2cm" margin-right="2cm">
          <fo:page-number/><fo:leader leader-pattern="space" /><fo:retrieve-marker retrieve-class-name="form"/>
        </fo:block>
      </fo:static-content>
      <fo:flow flow-name="xsl-region-body">
        <xsl:for-each select="/ars_magica/arts/form/name">
          <xsl:variable name="form" select="."/>
          <xsl:for-each select="/ars_magica/arts/technique/name">
            <xsl:variable name="technique" select="."/>
            <xsl:if test="count($in/ars_magica/spells/spell[arts/technique=$technique and arts/form=$form]) &gt; 0">
              <xsl:call-template name="formtechnique">
                <xsl:with-param name="form" select="$form"/>
                <xsl:with-param name="technique" select="$technique"/>
              </xsl:call-template>
              <fo:block margin-bottom="9px" font-weight="normal"> </fo:block>
            </xsl:if>
          </xsl:for-each>
        </xsl:for-each>
      </fo:flow>
    </fo:page-sequence>
  </xsl:template>

  <xsl:template name="spellsection">
    <xsl:for-each select="/ars_magica/arts/form/name">
      <xsl:variable name="form" select="."/>
      <xsl:if test="($single = '') or ($single = $form)">
        <xsl:for-each select="/ars_magica/arts/technique/name">
          <xsl:variable name="technique" select="."/>

          <xsl:call-template name="spellblock">
            <xsl:with-param name="form" select="$form"/>
            <xsl:with-param name="technique" select="$technique"/>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:if>
    </xsl:for-each>
    <xsl:call-template name="spellindex"></xsl:call-template>
  </xsl:template>

  <xsl:template name="spellblock">
    <xsl:param name="form"/>
    <xsl:param name="technique"/>
    <fo:page-sequence master-reference="spell-list">
      <fo:static-content flow-name="xsl-region-before">
        <xsl:if test="$edit = ''">
          <fo:block-container absolute-position="absolute" top="0cm" left="0cm" width="{$width}" height="{$height}"
            background-image="images/{$form}-paper.jpg">
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
        <xsl:call-template name="formtechnique">
          <xsl:with-param name="form" select="$form"/>
          <xsl:with-param name="technique" select="$technique"/>
        </xsl:call-template>
      </fo:flow>
    </fo:page-sequence>
  </xsl:template>

  <xsl:include href="file:./core.xsl"/>
 
</xsl:stylesheet>