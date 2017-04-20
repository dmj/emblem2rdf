<xsl:transform version="2.0"
               xpath-default-namespace="http://www.loc.gov/mods/v3"
               xmlns:dct="http://purl.org/dc/terms/"
               xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
               xmlns:foaf="http://xmlns.com/foaf/0.1/"
               xmlns:marcrel="http://id.loc.gov/vocabulary/relators/"
               xmlns:owl="http://www.w3.org/2002/07/owl#"
               xmlns:skos="http://www.w3.org/2004/02/skos/core#"
               xmlns:xsd="http://www.w3.org/2001/XMLSchema"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml" encoding="utf-8" indent="yes" omit-xml-declaration="yes"/>

  <xsl:template match="mods">
    <dct:BibliographicResource>
      <owl:sameAs rdf:resource="http://uri.gbv.de/document/opac-de-23:ppn:{recordInfo/recordIdentifier[@source = 'DE-23']}"/>
      <xsl:apply-templates/>
    </dct:BibliographicResource>
  </xsl:template>

  <xsl:template match="mods/titleInfo[not(preceding-sibling::titleInfo)]">
    <dct:title>
      <xsl:value-of select="(nonSort, title)" separator=" "/>
      <xsl:if test="subTitle">
        <xsl:text> : </xsl:text>
        <xsl:value-of select="subTitle"/>
      </xsl:if>
    </dct:title>
  </xsl:template>

  <xsl:template match="language/languageTerm[@type = 'code'][@authority = 'iso639-2b']">
    <dct:language rdf:resource="http://id.loc.gov/vocabulary/iso639-2/{.}"/>
  </xsl:template>

  <xsl:template match="subject[@authority = 'gnd']/topic[@valueURI]">
    <dct:subject>
      <skos:Concept>
        <owl:sameAs rdf:resource="{@valueURI}"/>
        <skos:prefLabel><xsl:value-of select="."/></skos:prefLabel>
      </skos:Concept>
    </dct:subject>
  </xsl:template>

  <xsl:template match="dateIssued">
    <dct:issued><xsl:value-of select="."/></dct:issued>
  </xsl:template>

  <xsl:template match="name[@type = 'personal'][role/roleTerm[@authority = 'marcrelator' and @type = 'code']]">
    <xsl:element name="marcrel:{role/roleTerm[@authority = 'marcrelator' and @type = 'code']}">
      <dct:Agent>
        <xsl:if test="@valueURI">
          <owl:sameAs rdf:resource="{@valueURI}"/>
        </xsl:if>
        <foaf:name><xsl:value-of select="displayForm"/></foaf:name>
      </dct:Agent>
    </xsl:element>
  </xsl:template>

  <xsl:template match="recordInfo/recordIdentifier[@source = 'DE-23']">
    <foaf:page rdf:resource="http://opac.lbs-braunschweig.gbv.de/DB=2/PPN?PPN={.}"/>
  </xsl:template>

  <xsl:template match="text()"/>

</xsl:transform>
