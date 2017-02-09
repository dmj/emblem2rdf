<?xml version="1.0" encoding="utf-8"?>
<xsl:transform version="2.0"
               xpath-default-namespace="http://diglib.hab.de/rules/schema/emblem"
               xmlns:cnt="http://www.w3.org/2011/content#"
               xmlns:dct="http://purl.org/dc/terms/"
               xmlns:emblem="http://uri.hab.de/ontology/emblem#"
               xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
               xmlns:skos="http://www.w3.org/2004/02/skos/core#"
               xmlns:tei="http://www.tei-c.org/ns/1.0"
               xmlns:xlink="http://www.w3.org/1999/xlink"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml" encoding="utf-8" indent="yes"/>

  <xsl:template match="text()"/>

  <xsl:template match="/">
    <rdf:RDF>
      <xsl:apply-templates/>
    </rdf:RDF>
  </xsl:template>
  
  <xsl:template match="emblem">
    <emblem:Emblem>
      <xsl:if test="@globalID"><xsl:attribute name="rdf:about" select="@globalID"/></xsl:if>
      <xsl:apply-templates select="@xlink:href"/>
      
      <xsl:copy-of select="emblem:label(.)"/>
      <xsl:apply-templates/>
    </emblem:Emblem>
  </xsl:template>

  <xsl:template match="motto">
    <emblem:hasPart>
      <emblem:Motto>
        <xsl:if test="@globalID"><xsl:attribute name="rdf:about" select="@globalID"/></xsl:if>
        <xsl:apply-templates select="@xlink:href"/>
        
        <xsl:apply-templates/>
      </emblem:Motto>
    </emblem:hasPart>
  </xsl:template>

  <xsl:template match="subscriptio">
    <emblem:hasPart>
      <emblem:Subscriptio>
        <xsl:if test="@globalID"><xsl:attribute name="rdf:about" select="@globalID"/></xsl:if>
        <xsl:apply-templates select="@xlink:href"/>
        
        <xsl:apply-templates/>
      </emblem:Subscriptio>
    </emblem:hasPart>
  </xsl:template>

  <xsl:template match="pictura">
    <emblem:hasPart>
      <emblem:Pictura>
        <xsl:if test="@globalID"><xsl:attribute name="rdf:about" select="@globalID"/></xsl:if>
        <xsl:apply-templates select="@xlink:href"/>
        
        <xsl:if test="@medium = 'engraving'">
          <dct:medium>
            <skos:Concept rdf:about="http://vocab.getty.edu/aat/300041340">
              <skos:prefLabel xml:lang="de">Stich (Gravur)</skos:prefLabel>
            </skos:Concept>
          </dct:medium>   
        </xsl:if>
        <xsl:for-each select="iconclass">
          <dct:subject>
            <skos:Concept rdf:about="http://iconclass.org/{encode-for-uri(skos:notation)}">
              <skos:notation rdf:datatype="http://uri.hab.de/ontology/diglib-types#Iconclass">
                <xsl:value-of select="skos:notation"/>
              </skos:notation>
              <xsl:for-each select="skos:prefLabel">
                <skos:prefLabel>
                  <xsl:copy-of select="@xml:lang"/>
                  <xsl:value-of select="normalize-space()"/>
                </skos:prefLabel>
              </xsl:for-each>
            </skos:Concept>
          </dct:subject>
        </xsl:for-each>
      </emblem:Pictura>
    </emblem:hasPart>
  </xsl:template>

  <xsl:template match="transcription">
    <emblem:hasTextSegment>
      <emblem:TextSegment>
        <xsl:if test="@globalID"><xsl:attribute name="rdf:about" select="@globalID"/></xsl:if>
        <xsl:apply-templates select="@xlink:href"/>
        
        <xsl:if test="matches(@xml:lang, '^[a-zA-Z]{2,3}$')">
          <dct:language rdf:datatype="http://purl.org/dc/terms/RFC4646">
            <xsl:value-of select="@xml:lang"/>
          </dct:language>
        </xsl:if>
        <xsl:if test="*">
          <dct:hasFormat>
            <cnt:ContentAsXML>
              <dct:format>application/tei+xml</dct:format>
              <cnt:rest rdf:parseType="Literal">
                <xsl:apply-templates mode="copy-literal" select="*"/>
              </cnt:rest>
            </cnt:ContentAsXML>
          </dct:hasFormat>
        </xsl:if>
      </emblem:TextSegment>
    </emblem:hasTextSegment>
  </xsl:template>

  <xsl:template match="@xlink:href">
    <emblem:isShownAt rdf:resource="{.}"/>
  </xsl:template>

  <xsl:template mode="copy-literal" match="node() | @*">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="node() | @*" mode="copy-literal"/>
    </xsl:copy>
  </xsl:template>

  <xsl:function name="emblem:label" as="element()">
    <xsl:param name="emblem" as="element()"/>
    <skos:prefLabel>
      <xsl:if test="starts-with($emblem/@globalID, 'http://hdl.handle.net/10111/EmblemRegistry:')">
        <xsl:value-of select="substring($emblem/@globalID, 44)"/>
      </xsl:if>
      <xsl:text> </xsl:text>
      <xsl:if test="$emblem/motto/transcription/tei:p">
        <xsl:variable name="tokens" select="tokenize(($emblem/motto/transcription/tei:p)[1], '[:,-.]')"/>
        <xsl:value-of select="normalize-space($tokens[1])"/>
        <xsl:if test="count($tokens) &gt; 1">
          <xsl:text>…</xsl:text>
        </xsl:if>
      </xsl:if>
    </skos:prefLabel>
  </xsl:function>
  
</xsl:transform>
