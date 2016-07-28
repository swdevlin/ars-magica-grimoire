<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:java="http://xml.apache.org/xslt/java"
  exclude-result-prefixes="java" xmlns:fo="http://www.w3.org/1999/XSL/Format">  
  
  <xsl:template match="p">
    <fo:block text-indent="1em" font-family="{$textfont}" font-size="8pt" font-weight="normal"><xsl:apply-templates/></fo:block>
  </xsl:template>

  <xsl:template match="booklist">
    <fo:inline font-family="Lauren C. Brown" font-size="10pt"> Ars Magica (<xsl:value-of select="count($in/ars_magica/spells/spell[not(@source)])"/> spells),</fo:inline>
    <xsl:for-each select="$in/ars_magica/books/book">
      <xsl:sort select="name"/>
      <xsl:variable name="abbrev" select="abbreviation"/>
      <xsl:if test="position() = last()"><xsl:text> </xsl:text>and </xsl:if><fo:inline font-family="Lauren C. Brown" font-size="10pt"><xsl:value-of select="name" /><xsl:text> </xsl:text>(<xsl:value-of select="abbreviation" />, <xsl:value-of select="count($in/ars_magica/spells/spell[@source=$abbrev])"/> spells)<xsl:if test="position() &lt; last()">,</xsl:if></fo:inline>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template match="p" mode="preface">
    <xsl:variable name="indent">
      <xsl:choose>
        <xsl:when test="@indent = 'false'">0em</xsl:when>
        <xsl:otherwise>1em</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="colour">
      <xsl:choose>
        <xsl:when test="@colour = 'hand'"><xsl:value-of select="$handcolour"/></xsl:when>
        <xsl:when test="@colour"><xsl:value-of select="@colour"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="$textcolour"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="font">
      <xsl:choose>
        <xsl:when test="@font = 'hand'"><xsl:value-of select="$handfont"/></xsl:when>
        <xsl:when test="@font"><xsl:value-of select="@font"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="$textfont"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="size">
      <xsl:choose>
        <xsl:when test="@size"><xsl:value-of select="@size"/></xsl:when>
        <xsl:otherwise>8pt</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <fo:block text-indent="{$indent}" color="{$colour}" font-family="{$font}" font-size="{$size}" font-weight="normal"><xsl:apply-templates/></fo:block>
  </xsl:template>

  <xsl:template match="spell-link"><xsl:variable name="sname" select="@name"/><fo:inline font-style="italic"><xsl:value-of select="@name"/> <fo:basic-link internal-destination="{generate-id($sortedspells/spell[name=$sname])}"> (pg. <fo:page-number-citation ref-id="{generate-id($sortedspells/spell[name=$sname])}" />)</fo:basic-link></fo:inline></xsl:template>
  
  <xsl:template match="table">
    <fo:table>
      <fo:table-header>
        <xsl:for-each select="columns/column">
          <xsl:choose>
            <xsl:when test="@width">
              <xsl:variable name="w" select="@width"/>
              <fo:table-cell width="{$w}"><fo:block font-family="{$textfont}" font-size="8pt" font-weight="bold"><xsl:value-of select="."/></fo:block></fo:table-cell>
            </xsl:when>
            <xsl:otherwise>
              <fo:table-cell><fo:block font-size="8pt" font-family="{$textfont}" font-weight="bold"><xsl:value-of select="."/></fo:block></fo:table-cell>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </fo:table-header>
      <fo:table-body>
        <xsl:for-each select="row">
          <fo:table-row table-layout="fixed">
            <xsl:for-each select="cell">
              <fo:table-cell><fo:block font-family="{$textfont}" font-size="8pt"><xsl:value-of select="."/></fo:block></fo:table-cell>
            </xsl:for-each>
          </fo:table-row>
        </xsl:for-each>
      </fo:table-body>
    </fo:table>
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
      <xsl:when test="range = 'Veil'">, +3 Veil</xsl:when>
      <xsl:when test="range = 'Arcane Connection'">, +4 Arcane Connection</xsl:when>
      <xsl:when test="range = 'Symbol'">, +4 Symbol</xsl:when>
      <xsl:when test="range = 'Lunar'">, +4 Lunar</xsl:when>
      <xsl:when test="range = 'Ground'">, +4 Ground</xsl:when>
      <xsl:when test="range = 'Unlimited'">, +4 Unlimited</xsl:when>
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
      <xsl:when test="duration = 'Event'">, +3 Event</xsl:when>
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
      <xsl:when test="target = 'Barrier'">, +3 Barrier</xsl:when>
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
  <xsl:if test="$source = 'true'">
    <fo:inline font-size="6pt" color="{$handcolour}"><xsl:text> </xsl:text><xsl:value-of select="@source"/><xsl:text> </xsl:text><xsl:value-of select="@page"/></fo:inline>
  </xsl:if>
  </xsl:template>

  <xsl:template match="requisite">
    <xsl:value-of select="." /><xsl:if test="position() &lt; last()">, </xsl:if>
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

  <xsl:template name="spells-at-level">
    <xsl:param name="form"/>
    <xsl:param name="technique"/>
    <xsl:param name="level"/>
    <xsl:for-each select="$sortedspells/spell[arts/technique=$technique and arts/form=$form and level=$level]">
      <fo:block page-break-inside="avoid">
        <fo:block id="{generate-id(.)}" font-family="{$textfont}" font-size="9pt" font-weight="normal">
          <fo:inline><xsl:value-of select="name" /></fo:inline><xsl:call-template name="source"/>
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

  <xsl:template name="formtechnique">
    <xsl:param name="form"/>
    <xsl:param name="technique"/>
    <xsl:variable name="color"><xsl:value-of select="/ars_magica/arts/form[name=$form]/color"/></xsl:variable>
    <fo:block keep-with-next.within-page="always" color="{$color}" font-family="{$artfont}" font-size="12pt" margin-bottom="8px" font-weight="normal">
      <fo:marker marker-class-name="form"><xsl:value-of select="$form"/></fo:marker>
      <fo:marker marker-class-name="technique"><xsl:value-of select="$technique"/></fo:marker>
      <xsl:value-of select="$technique"/><xsl:text> </xsl:text><xsl:value-of select="$form"/> Spells
    </fo:block>
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
  </xsl:template>
  
</xsl:stylesheet>