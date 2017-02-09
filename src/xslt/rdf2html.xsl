<xsl:transform version="2.0"
               exclude-result-prefixes="#all"
               xpath-default-namespace="http://uri.hab.de/ontology/emblem#"
               xmlns:fun="http://dmaus.name/ns/xslt"
               xmlns:dct="http://purl.org/dc/terms/"
               xmlns:bibo="http://purl.org/ontology/bibo/"
               xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
               xmlns:skos="http://www.w3.org/2004/02/skos/core#"
               xmlns:xsd="http://www.w3.org/2001/XMLSchema"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="html" encoding="utf-8" indent="yes"
              doctype-system="http://www.w3.org/TR/html4/strict.dtd"
              doctype-public="-//W3C//DTD HTML 4.01//EN"/>

  <xsl:template match="/rdf:RDF">
    <html>
      <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
        <title><xsl:value-of select="Emblem/skos:prefLabel[1]"/></title>
      </head>
      <body>
        <xsl:apply-templates/>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="Motto | Subscriptio | Pictura">
    <div>
      <span>
        <xsl:value-of select="local-name()"/>
      </span>
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="TextSegment">
    <div>
      <xsl:if test="dct:language">
        <span lang="{dct:language}">
          <xsl:value-of select="dct:language"/>
        </span>
      </xsl:if>
      <xsl:if test="isShownAt/@rdf:resource">
        <a href="{isShownAt/@rdf:resource}">
          <xsl:value-of select="isShownAt/@rdf:resource"/>
        </a>
      </xsl:if>
    </div>
  </xsl:template>

</xsl:transform>
