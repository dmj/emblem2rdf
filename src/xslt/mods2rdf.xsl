<xsl:transform version="2.0"
               exclude-result-prefixes="#all"
               xpath-default-namespace="http://www.loc.gov/mods/v3"
               xmlns:bibo="http://purl.org/ontology/bibo/"
               xmlns:dct="http://purl.org/dc/terms/"
               xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="mods">
    <bibo:Document>
      <xsl:apply-templates/>
    </bibo:Document>
  </xsl:template>

  <xsl:template match="text()"/>

</xsl:transform>
