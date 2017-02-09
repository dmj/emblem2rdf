<xsl:transform version="2.0"
               xmlns:emblem="http://diglib.hab.de/rules/schema/emblem"
               xmlns:dct="http://purl.org/dc/terms/"
               xmlns:bibo="http://purl.org/ontology/bibo/"
               xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:include href="mods2rdf.xsl"/>

  <xsl:template match="emblem:biblioDesc">
    <dct:isPartOf>
      <xsl:apply-templates/>
    </dct:isPartOf>
  </xsl:template>

</xsl:transform>
