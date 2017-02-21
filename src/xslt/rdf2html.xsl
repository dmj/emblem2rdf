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

  <xsl:output method="html" encoding="utf-8" indent="yes"/>

  <xsl:template match="Emblem">
    <html>
      <head>
        <title><xsl:value-of select="skos:prefLabel"/></title>
        <style type="text/css">
          samp { display: block; }
        </style>
      </head>
      <body>
        <table>
          <caption><xsl:value-of select="skos:prefLabel"/></caption>
          <tbody>
            <xsl:for-each select="hasPart/Motto">
              <tr>
                <th colspan="2">Motto</th>
              </tr>
              <xsl:call-template name="segments"/>
            </xsl:for-each>
            <xsl:for-each select="hasPart/Subscriptio">
              <tr>
                <th colspan="2">Subscriptio</th>
              </tr>
              <xsl:call-template name="segments"/>
            </xsl:for-each>
            <xsl:for-each select="hasPart/Pictura">
              <tr>
                <th colspan="2">Pictura</th>
              </tr>
              <tr>
                <td></td>
                <td>
                  <xsl:if test="isShownAt">
                    <a hreF="{isShownAt/@rdf:resource}">
                      <xsl:value-of select="isShownAt/@rdf:resource"/>
                    </a>
                  </xsl:if>
                </td>
              </tr>
            </xsl:for-each>
          </tbody>
        </table>
      </body>
    </html>
  </xsl:template>

  <xsl:template name="segments">
    <xsl:for-each select="hasTextSegment/TextSegment">
      <tr>
        <td>
          <xsl:value-of select="dct:language"/>
        </td>
        <td>
          <xsl:if test="isShownAt">
            <a hreF="{isShownAt/@rdf:resource}">
              <xsl:value-of select="isShownAt/@rdf:resource"/>
            </a>
          </xsl:if>
          <xsl:apply-templates select="dct:hasFormat/*"/>
        </td>
      </tr>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="cnt:ContentAsXML">
    <samp title="{dct:format}">
      <xsl:copy-of select="eg:example(cnt:rest/*)"/>
    </samp>
  </xsl:template>

  <xsl:template match="text()"/>

</xsl:transform>
