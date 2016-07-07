<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:java="http://xml.apache.org/xslt/java"
  exclude-result-prefixes="java" xmlns:fo="http://www.w3.org/1999/XSL/Format">  
  
  <xsl:template match="p">
    <fo:block text-indent="1em" font-family="{$textfont}" font-size="8pt" font-weight="normal"><xsl:apply-templates/></fo:block>
  </xsl:template>

  <xsl:template match="reference"><fo:inline font-style="italic"><xsl:value-of select="."/></fo:inline>
    <xsl:choose>
      <xsl:when test="@page != ''">, page <xsl:value-of select="@page"/></xsl:when>
      <xsl:when test="@chapter != ''">, chapter <xsl:value-of select="@chapter"/></xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="flavour">
    <fo:block text-indent="1em" font-family="{$textfont}" font-size="8pt" font-weight="normal" font-style="italic"><xsl:value-of select="." /></fo:block>
  </xsl:template>

  <xsl:template name="spell-guidelines">
    <xsl:value-of select="guideline/modifiers/base"/>
    <xsl:choose>
      <xsl:when test="range = 'Personal'" />
      <xsl:when test="range = 'Adelphixis'" />
      <xsl:when test="range = 'Touch'">, +1 Touch</xsl:when>
      <xsl:when test="range = 'Eye'">, +1 Eye</xsl:when>
      <xsl:when test="range = 'Voice'">, +2 Voice</xsl:when>
      <xsl:when test="range = 'Road'">, +2 Road</xsl:when>
      <xsl:when test="range = 'Water-way'">, +3 Water-way</xsl:when>
      <xsl:when test="range = 'Sight'">, +3 Sight</xsl:when>
      <xsl:when test="range = 'Arcane Connection'">, +4 Arcane Connection</xsl:when>
      <xsl:when test="range = 'Symbol'">, +4 Symbol</xsl:when>
      <xsl:when test="range = 'Ground'">, +4 Ground</xsl:when>
      <xsl:otherwise>RANGE ERROR</xsl:otherwise>
    </xsl:choose>
    <xsl:choose>
      <xsl:when test="duration = 'Momentary'" />
      <xsl:when test="duration = 'Special'" />
      <xsl:when test="duration = 'Dream'">, +1 Dream</xsl:when>
      <xsl:when test="duration = 'Concentration'">, +1 Concentration</xsl:when>
      <xsl:when test="duration = 'Performance'">, +1 Performance</xsl:when>
      <xsl:when test="duration = 'Diameter'">, +1 Diameter</xsl:when>
      <xsl:when test="duration = 'Sun'">, +2 Sun</xsl:when>
      <xsl:when test="duration = 'Ring'">, +2 Ring</xsl:when>
      <xsl:when test="duration = 'Fire'">, +3 Fire</xsl:when>
      <xsl:when test="duration = 'Moon'">, +3 Moon</xsl:when>
      <xsl:when test="duration = 'Month'">, +3 Month</xsl:when>
      <xsl:when test="duration = 'Helstar'">, +3 Helstar</xsl:when>
      <xsl:when test="duration = 'Bargain'">, +3 Bargain</xsl:when>
      <xsl:when test="duration = 'Until'">, +4 Until</xsl:when>
      <xsl:when test="duration = 'Year'">, +4 Year</xsl:when>
      <xsl:when test="duration = 'Year +1'">, +4 Year + 1</xsl:when>
      <xsl:when test="duration = 'Symbol'">, +4 Symbol</xsl:when>
      <xsl:otherwise>DURATION ERROR</xsl:otherwise>
    </xsl:choose>
    <xsl:choose>
      <xsl:when test="target = 'Individual'" />
      <xsl:when test="target = 'Unborn Child'" />
      <xsl:when test="target = 'Taste'" />
      <xsl:when test="target = 'Circle'" />
      <xsl:when test="target = 'Flavour'" />
      <xsl:when test="target = 'Dream'" />
      <xsl:when test="target = 'Part'">, +1 Part</xsl:when>
      <xsl:when test="target = 'Texture'">, +1 Texture</xsl:when>
      <xsl:when test="target = 'Touch'">, +1 Touch</xsl:when>
      <xsl:when test="target = 'Group'">, +2 Group</xsl:when>
      <xsl:when test="target = 'Pair'">, +2 Pair</xsl:when>
      <xsl:when test="target = 'Smell'">, +2 Smell</xsl:when>
      <xsl:when test="target = 'Scent'">, +2 Scent</xsl:when>
      <xsl:when test="target = 'Special'">, +2 Special</xsl:when>
      <xsl:when test="target = 'Room'">, +2 Room</xsl:when>
      <xsl:when test="target = 'Sight'">, +3 Sight</xsl:when>
      <xsl:when test="target = 'Hearing'">, +3 Hearing</xsl:when>
      <xsl:when test="target = 'Sound'">, +3 Sound</xsl:when>
      <xsl:when test="target = 'Structure'">, +3 Structure</xsl:when>
      <xsl:when test="target = 'Bloodline'">, +3 Bloodline</xsl:when>
      <xsl:when test="target = 'Spectacle'">, +4 Spectacle</xsl:when>
      <xsl:when test="target = 'Boundary'">, +4 Boundary</xsl:when>
      <xsl:when test="target = 'Community'">, +4 Community</xsl:when>
      <xsl:when test="target = 'Symbol'">, +4 Symbol</xsl:when>
      <xsl:when test="target = 'Vision'">, +4 Vision</xsl:when>
      <xsl:otherwise>TARGET ERROR</xsl:otherwise>
    </xsl:choose>
    <xsl:for-each select="guideline/modifiers/modifier">, <xsl:value-of select="." /></xsl:for-each>
  </xsl:template>

  <xsl:template match="range">
    <xsl:choose>
      <xsl:when test=". = 'Personal'">Personal</xsl:when>
      <xsl:when test=". = 'Touch'">Touch</xsl:when>
      <xsl:when test=". = 'Voice'">Voice</xsl:when>
      <xsl:otherwise><xsl:value-of select="." /></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="duration">
    <xsl:choose>
      <xsl:when test=". = 'Momentary'">Momentary</xsl:when>
      <xsl:otherwise><xsl:value-of select="." /></xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="source">
  <fo:inline font-size="6pt" color="{$handcolour}"><xsl:text> </xsl:text><xsl:value-of select="@source"/><xsl:text> </xsl:text><xsl:value-of select="@page"/></fo:inline>
  </xsl:template>

  <xsl:template match="requisite">
    <xsl:value-of select="." /><xsl:if test="position() &lt; last()">, </xsl:if>
  </xsl:template>

  <xsl:template match="requisite" mode="guideline">
    , <xsl:choose>
        <xsl:when test="@free = 'true'"><xsl:value-of select="." /> requisite free</xsl:when>
        <xsl:otherwise>+1 <xsl:value-of select="." /> requisite<xsl:if test="@note != ''"><xsl:text> </xsl:text><xsl:value-of select="@note" /></xsl:if></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="text()"><xsl:copy/></xsl:template>

  <xsl:template match="strong"><fo:inline font-weight="bold"><xsl:value-of select="."/></fo:inline></xsl:template>

  <xsl:template match="emphasis"><fo:inline font-style="italic"><xsl:value-of select="."/></fo:inline></xsl:template>

  <xsl:template match="p" mode="notes"><fo:block color="{$handcolour}" space-before="2.5pt" text-indent="1em" font-size="9pt"><xsl:apply-templates/></fo:block></xsl:template>

  <xsl:template match="p" mode="guideline"><fo:block color="{$handcolour}" space-before="2.5pt" text-indent="1em" font-size="9pt"><xsl:apply-templates/></fo:block></xsl:template>

</xsl:stylesheet>