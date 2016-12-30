<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:java="http://xml.apache.org/xslt/java"
  exclude-result-prefixes="java" xmlns:fo="http://www.w3.org/1999/XSL/Format">
  <xsl:param name="single" select="''"/>
  <xsl:param name="edit" select="''"/>
  <xsl:param name="cover" select="'true'"/>
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

  <xsl:variable name="spellsbybook">
    <xsl:for-each select="$in/ars_magica/spells/spell">
      <xsl:sort select="@source"/>
      <xsl:sort select="@page" data-type="number"/>
      <xsl:sort select="name"/>
      <xsl:copy-of select="current()"/>
    </xsl:for-each>
  </xsl:variable>

  <xsl:include href="file:./styles.xsl"/>

  <xsl:template match="/">
    <fo:root>
      <fo:layout-master-set>
        <fo:simple-page-master master-name="inner-leaf" page-height="{$height}" page-width="{$width}">
          <fo:region-body margin="2cm" margin-right="2cm" />
          <fo:region-before region-name="xsl-region-before" extent="3in"/>
          <fo:region-after region-name="xsl-region-after" extent=".25in" />
        </fo:simple-page-master>

        <fo:simple-page-master master-name="form-notes" page-height="{$height}" page-width="{$width}">
          <fo:region-body column-count="{$textcols}" margin="2cm"/>
          <fo:region-before region-name="xsl-region-before" margin-top="0in" extent="3in" />
          <fo:region-after region-name="xsl-region-after" extent=".5in" />
        </fo:simple-page-master>

        <fo:simple-page-master master-name="arts-guideline" page-height="{$height}" page-width="{$width}">
          <fo:region-body column-count="{$textcols}" margin="2cm"/>
          <fo:region-before region-name="xsl-region-before" extent="1.9cm" />
          <fo:region-after region-name="xsl-region-after" extent=".5in" />
        </fo:simple-page-master>

        <fo:simple-page-master master-name="spell-list" page-height="{$height}" page-width="{$width}">
          <fo:region-body column-count="{$cols}" margin-bottom="0.5in"  margin-top="0.5in" margin-left="2cm" margin-right="2cm"/>
          <fo:region-before region-name="xsl-region-before" extent=".5in" />
          <fo:region-after region-name="xsl-region-after" extent=".5in" margin-right="2cm"/>
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

      <xsl:for-each select="/ars_magica/arts/form/name">
        <xsl:variable name="form" select="."/>
        <xsl:if test="($single = '' ) or ($single = .)">
          <xsl:call-template name="form-notes">
            <xsl:with-param name="form" select="$form"/>
          </xsl:call-template>
          <xsl:for-each select="/ars_magica/arts/technique/name">
            <xsl:variable name="technique" select="."/>
            <xsl:call-template name="art-guidelines">
              <xsl:with-param name="form" select="$form"/>
              <xsl:with-param name="technique" select="$technique"/>
            </xsl:call-template>

            <xsl:call-template name="spellblock">
              <xsl:with-param name="form" select="$form"/>
              <xsl:with-param name="technique" select="$technique"/>
            </xsl:call-template>
          </xsl:for-each>
        </xsl:if>
      </xsl:for-each>

      <xsl:call-template name="bookindex"></xsl:call-template>
      <xsl:call-template name="spellindex"></xsl:call-template>

    </fo:root>
  </xsl:template>

  <xsl:template name="form-notes">
    <xsl:param name="form"/>

    <fo:page-sequence master-reference="form-notes">
      <fo:static-content flow-name="xsl-region-before">
        <xsl:if test="$edit = ''">
          <fo:block-container absolute-position="absolute" top="0cm" left="0cm" width="{$width}" height="{$height}">
            <fo:block>
              <fo:external-graphic src="images/{$form}-paper{wide}.jpg"  content-height="scale-to-fit" height="{$height}"  content-width="{$width}" scaling="non-uniform"/>
            </fo:block>
          </fo:block-container>
        </xsl:if>
        <fo:block></fo:block>
      </fo:static-content>
      <fo:static-content flow-name="xsl-region-after">
        <fo:block color="{$handcolour}" text-align-last="justify" font-family="{$textfont}" font-size="8pt" font-weight="normal" margin-left="2cm" margin-right="2cm">
          <fo:page-number/><fo:leader leader-pattern="space" /><xsl:value-of select="$form"/> 
        </fo:block>
      </fo:static-content>
      <fo:flow flow-name="xsl-region-body">
        <fo:block id="{$form}" text-align="center" font-family="{$artfont}" font-size="24pt" font-weight="normal">
          <xsl:value-of select="$form"/>
        </fo:block>
        <xsl:apply-templates select="/ars_magica/arts/form[name = $form]/description/p" mode="notes"/>
      </fo:flow>
    </fo:page-sequence>
  </xsl:template>

  <xsl:template name="art-guidelines">
    <xsl:param name="form"/>
    <xsl:param name="technique"/>
    <xsl:param name="toc_key"><xsl:value-of select="$technique"/> <xsl:value-of select="$form"/></xsl:param>

    <fo:page-sequence master-reference="arts-guideline">
      <fo:static-content flow-name="xsl-region-before">
        <xsl:if test="$edit = ''">
          <fo:block-container absolute-position="absolute" top="0cm" left="0cm" width="{$width}" height="{$height}">
            <fo:block>
              <fo:external-graphic src="images/{$form}-paper{$wide}.jpg" content-height="scale-to-fit" height="{$height}" content-width="{$width}" scaling="non-uniform"/>
            </fo:block>
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
        <fo:block  id="{$toc_key}" text-align="center" color="{$handcolour}" font-family="{$artfont}" font-size="18pt" font-weight="normal">
          <xsl:value-of select="$technique"/><xsl:text> </xsl:text><xsl:value-of select="$form"/>
        </fo:block>
        <xsl:apply-templates select="/ars_magica/arts_guidelines/arts_guideline[arts/form=$form and arts/technique=$technique]/description/p" mode="guideline"/>
        <fo:block space-before="3pt" font-size="8pt"><xsl:text> </xsl:text></fo:block>
        <xsl:if test="count(/ars_magica/arts_guidelines/arts_guideline[arts/form=$form and arts/technique=$technique]/guidelines/guideline) &gt; 0">
          <fo:table>
            <fo:table-body>
              <xsl:for-each select="/ars_magica/arts_guidelines/arts_guideline[arts/form=$form and arts/technique=$technique]/guidelines/guideline">
                <fo:table-row table-layout="fixed">
                  <fo:table-cell width="4.2em">
                    <fo:block font-size="8pt">
                      <xsl:if test="not(preceding-sibling::*[1]/level = level)">
                        <xsl:if test="level != 'General'">Level </xsl:if><xsl:value-of select="level"/>
                      </xsl:if>
                    </fo:block>
                  </fo:table-cell>    
                  <fo:table-cell>
                    <fo:block text-indent="-1em" font-size="8pt">
                      <xsl:if test="@mystery='true'"><fo:inline font-style="italic">Mystery </fo:inline></xsl:if>
                      <xsl:if test="@ritual='true'"><fo:inline font-style="italic">Ritual </fo:inline></xsl:if>
                      <xsl:if test="@faerie='true'"><fo:inline font-style="italic">Faerie </fo:inline></xsl:if>
                      <xsl:if test="@atlantean='true'"><fo:inline font-style="italic">Atlantean </fo:inline></xsl:if>
                      <xsl:apply-templates select="description" mode="guideline-notes"/><xsl:call-template name="source"/>
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
              </xsl:for-each>
            </fo:table-body>
          </fo:table>
        </xsl:if>
      </fo:flow>
    </fo:page-sequence>
  </xsl:template>

  <xsl:template match="description" mode="guideline-notes">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template name="spellblock">
    <xsl:param name="form"/>
    <xsl:param name="technique"/>
    <fo:page-sequence master-reference="spell-list">
      <fo:static-content flow-name="xsl-region-before">
        <xsl:if test="$edit = ''">
          <fo:block-container absolute-position="absolute" top="0cm" left="0cm" width="{$width}" height="{$height}">
            <fo:block>
              <fo:external-graphic src="images/{$form}-paper{$wide}.jpg"  content-height="scale-to-fit" height="{$height}"  content-width="{$width}" scaling="non-uniform"/>
            </fo:block>
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
        <fo:block font-family="{$artfont}" font-size="12pt" margin-bottom="8px" font-weight="normal"><xsl:value-of select="$technique"/><xsl:text> </xsl:text><xsl:value-of select="$form"/> Spells</fo:block>
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
          <fo:block margin-bottom="4px"> </fo:block>
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
          <fo:block margin-bottom="4px"> </fo:block>
        </xsl:for-each>
      </fo:flow>
    </fo:page-sequence>
  </xsl:template>

  <xsl:include href="file:./core.xsl"/>
 
  <xsl:template match="toc" mode="preface">
    <fo:block page-break-before="always"/>
    <xsl:for-each select="$in/ars_magica/arts/form">
      <xsl:variable name="form" select="name"/>

      <fo:block font-family="{$textfont}" font-size="8pt" font-weight="normal" text-align-last="justify">
        <fo:basic-link internal-destination="{$form}">
          <xsl:value-of select="$form" />
          <fo:leader leader-pattern="dots" />
          <fo:page-number-citation ref-id="{$form}" />
        </fo:basic-link>
      </fo:block>
      <xsl:for-each select="$in/ars_magica/arts/technique">
        <xsl:variable name="technique" select="name"/>
        <xsl:variable name="toc_key"><xsl:value-of select="$technique"/> <xsl:value-of select="$form"/></xsl:variable>
        <fo:block margin-left="1em" font-family="{$textfont}" font-size="8pt" font-weight="normal" text-align-last="justify">
          <fo:basic-link internal-destination="{$toc_key}">
            <xsl:value-of select="$technique" />
            <fo:leader leader-pattern="dots" />
            <fo:page-number-citation ref-id="{$toc_key}" />
          </fo:basic-link>
        </fo:block>
      </xsl:for-each>
    </xsl:for-each>
    <fo:block margin-top="0.5em" font-family="{$textfont}" font-size="8pt" font-weight="normal" text-align-last="justify">
      <fo:basic-link internal-destination="book_index">
        Spells by Book<fo:leader leader-pattern="dots" /><fo:page-number-citation ref-id="book_index" />
      </fo:basic-link>
    </fo:block>
    <fo:block margin-top="0.5em" font-family="{$textfont}" font-size="8pt" font-weight="normal" text-align-last="justify">
      <fo:basic-link internal-destination="spell_index">
        Spell Index<fo:leader leader-pattern="dots" /><fo:page-number-citation ref-id="spell_index" />
      </fo:basic-link>
    </fo:block>
  </xsl:template>
 
</xsl:stylesheet>