<xsl:transform version="2.0"
               exclude-result-prefixes="#all"
               xpath-default-namespace="http://uri.hab.de/ontology/emblem#"
               xmlns:cnt="http://www.w3.org/2011/content#"
               xmlns:dct="http://purl.org/dc/terms/"
               xmlns:eg="http://dmaus.name/ns/egxml"
               xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
               xmlns:skos="http://www.w3.org/2004/02/skos/core#"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:include href="egxml/egxml.xsl"/>

  <xsl:template match="Emblem">
    <html>
      <head>
        <title><xsl:value-of select="skos:prefLabel[1]"/></title>
        <link rel="stylesheet" href="../emblem.css"/>
      </head>
      <body>
        <h1><xsl:value-of select="skos:prefLabel[1]"/></h1>
        <xsl:apply-templates select="hasPart/Motto | hasPart/Subscriptio"/>
        <xsl:apply-templates select="hasPart/Pictura"/>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="Motto | Subscriptio">
    <div class="entity">
      <h2><xsl:value-of select="local-name()"/></h2>
      <xsl:for-each-group select="*" group-by="name()">
        <div class="property">
          <span class="label"><xsl:value-of select="local-name()"/></span>
          <span class="value">
            <xsl:apply-templates select="current-group()"/>
          </span>
        </div>
      </xsl:for-each-group>
    </div>
  </xsl:template>

  <xsl:template match="Pictura">
    <div class="entity">
      <h2>Pictura</h2>
      <xsl:for-each-group select="*" group-by="name()">
        <div class="property">
          <span class="label"><xsl:value-of select="local-name()"/></span>
          <span class="value">
            <xsl:apply-templates select="current-group()"/>
          </span>
        </div>
      </xsl:for-each-group>
    </div>
  </xsl:template>

  <xsl:template match="skos:Concept">
    <span>
      <xsl:value-of select="if (skos:notation) then skos:notation else skos:prefLabel" separator=" / "/>
    </span>
  </xsl:template>

  <xsl:template match="isShownAt | isShownBy">
    <a href="{@rdf:resource}"><xsl:value-of select="@rdf:resource"/></a>
  </xsl:template>

  <xsl:template match="text()"/>

</xsl:transform>
