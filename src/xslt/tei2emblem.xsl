<?xml version="1.0" encoding="utf-8"?>
<xsl:transform version="2.0"
               exclude-result-prefixes="xsd fun"
               xpath-default-namespace="http://www.tei-c.org/ns/1.0"
               xmlns:emblem="http://diglib.hab.de/rules/schema/emblem"
               xmlns:fun="http://dmaus.name/ns/xslfun"
               xmlns:skos="http://www.w3.org/2004/02/skos/core#"
               xmlns:xlink="http://www.w3.org/1999/xlink"
               xmlns:xsd="http://www.w3.org/2001/XMLSchema"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml" encoding="utf-8" indent="yes"/>

  <xsl:template match="text()"/>
  <xsl:template match="text()" mode="emblem:transcription"/>

  <xsl:template match="/">
    <emblem:biblioDesc>
      <emblem:copyDesc>
        <emblem:copyID>{...FIXME...}</emblem:copyID>
        <emblem:owner countryCode="DE" institutionCode="hab">Herzog August Bibliothek Wolfenbüttel</emblem:owner>
      </emblem:copyDesc>
      <xsl:for-each-group select="//div[starts-with(@type, 'emblem_')]" group-by="@n">
        <xsl:sort select="@n"/>
        <emblem:emblem globalID="http://hdl.handle.net/10111/EmblemRegistry:{@n}">
          <xsl:apply-templates select="current-group()[@type = 'emblem_motto']"/>
          <xsl:apply-templates select="current-group()[@type = 'emblem_pictura']"/>
          <xsl:apply-templates select="current-group()[@type = 'emblem_subscriptio']"/>
        </emblem:emblem>
      </xsl:for-each-group>
    </emblem:biblioDesc>
  </xsl:template>

  <xsl:template match="div[@type = 'emblem_motto']">
    <emblem:motto>
      <xsl:apply-templates mode="emblem:transcription" select="."/>
    </emblem:motto>
  </xsl:template>

  <xsl:template match="div[@type = 'emblem_subscriptio']">
    <emblem:subscriptio>
      <xsl:apply-templates mode="emblem:transcription" select="."/>
    </emblem:subscriptio>
  </xsl:template>

  <xsl:template match="div[@type = 'emblem_pictura']">
    <emblem:pictura medium="engraving" xlink:href="{fun:resolve-page-url(substring(@facs, 2))}">
      <xsl:if test="id(substring(@facs, 2))/@n">
        <xsl:attribute name="page" select="id(substring(@facs, 2))/@n"/>
      </xsl:if>
      <xsl:apply-templates/>
    </emblem:pictura>
  </xsl:template>

  <xsl:template match="term[@type = 'ICONCLASS'][parent::index[@indexName = 'notation']]">
    <emblem:iconclass>
      <skos:notation><xsl:value-of select="@key"/></skos:notation>
      <skos:prefLabel xml:lang="{@xml:lang}"><xsl:value-of select="text()"/></skos:prefLabel>
      <xsl:for-each select="../index[@indexName = 'bsw']/term">
        <emblem:keyword xml:lang="{@xml:lang}"><xsl:value-of select="text()"/></emblem:keyword>
      </xsl:for-each>
    </emblem:iconclass>
  </xsl:template>

  <xsl:template match="div" mode="emblem:transcription">
    <emblem:transcription xlink:href="{fun:resolve-page-url(substring(@facs, 2))}">
      <xsl:if test="id(substring(@facs, 2))/@n">
        <xsl:attribute name="page" select="id(substring(@facs, 2))/@n"/>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="count(*) = 1">
          <xsl:if test="*/@xml:lang">
            <xsl:copy-of select="*/@xml:lang"/>
          </xsl:if>
          <xsl:if test="normalize-space(*)">
            <xsl:apply-templates mode="copy-content"/>
          </xsl:if>
        </xsl:when>
        <xsl:otherwise>
          <xsl:element name="p" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:apply-templates mode="copy-content"/>
          </xsl:element>
        </xsl:otherwise>
      </xsl:choose>
    </emblem:transcription>
  </xsl:template>

  <xsl:template mode="copy-content" match="*"/>
  <xsl:template mode="copy-content" match="p | lg | l | head | orig">
    <xsl:element name="{local-name()}" namespace="http://www.tei-c.org/ns/1.0">
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates mode="copy-content"/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template mode="copy-content" match="text()">
    <xsl:if test="normalize-space()">
      <xsl:copy/>
    </xsl:if>
  </xsl:template>

  <xsl:function name="fun:resolve-page-url" as="xsd:anyURI">
    <xsl:param name="identifier" as="xsd:string"/>
    <xsl:variable name="tokens" select="tokenize($identifier, '_')"/>
    <xsl:value-of select="concat('http://diglib.hab.de/', $tokens[1], '/', $tokens[2], '/start.htm?image=', $tokens[3])"/>
  </xsl:function>
  
</xsl:transform>
