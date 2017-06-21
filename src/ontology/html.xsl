<xsl:transform version="1.0"
               xmlns:dct="http://purl.org/dc/terms/"
               xmlns:foaf="http://xmlns.com/foaf/0.1/"
               xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
               xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="html" encoding="utf-8" indent="yes"/>

  <xsl:template match="rdf:RDF">
    <html>
      <head>
        <title><xsl:value-of select="rdf:Description/dct:title"/></title>
        <style type="text/css">
          body { max-width: 60em; margin: 0 auto; }
          table { border-collapse: collapse; width: 100%; border: thin dotted grey; margin-bottom: 1em; }
          th, td { text-align: left; vertical-align: top; }
          tbody th { width: 15em; }
          thead th { background-color: black; color: white; }
          tr[lang=de] { font-size: small; }
        </style>
      </head>
      <body>
        <h1><xsl:value-of select="rdf:Description/dct:title"/></h1>
        <ul>
          <xsl:for-each select="rdf:Description/dct:creator/foaf:Person">
            <li>
              <xsl:value-of select="foaf:name"/>, Herzog August Bibliothek Wolfenbüttel
            </li>
          </xsl:for-each>
        </ul>
        <h2>Classes</h2>
        <xsl:for-each select="rdfs:Class">
          <xsl:sort select="@rdf:about"/>
          <table id="{substring-after(@rdf:about, '#')}">
            <thead>
              <tr>
                <th colspan="2"><xsl:value-of select="@rdf:about"/></th>
              </tr>
            </thead>
            <tbody>
              <xsl:if test="rdfs:subClassOf">
                <tr>
                  <th>Sub class of</th>
                  <td>
                    <a href="{rdfs:subClassOf/@rdf:resource}">
                      <xsl:value-of select="rdfs:subClassOf/@rdf:resource"/>
                    </a>
                  </td>
                </tr>
              </xsl:if>
              <tr lang="en">
                <th/>
                <td>
                  <xsl:value-of select="rdfs:comment[@xml:lang = 'en']"/>
                </td>
              </tr>
              <tr lang="de">
                <th/>
                <td>
                  <xsl:value-of select="rdfs:comment[@xml:lang = 'de']"/>
                </td>
              </tr>
            </tbody>
          </table>
        </xsl:for-each>

        <h2>Properties</h2>
        <xsl:for-each select="rdfs:Property">
          <xsl:sort select="@rdf:about"/>
          <table id="{substring-after(@rdf:about, '#')}">
            <thead>
              <tr>
                <th colspan="2"><xsl:value-of select="@rdf:about"/></th>
              </tr>
            </thead>
            <tbody>
              <xsl:if test="rdfs:subPropertyOf">
                <tr>
                  <th>Sub property of</th>
                  <td>
                    <a href="{rdfs:subPropertyOf/@rdf:resource}">
                      <xsl:value-of select="rdfs:subPropertyOf/@rdf:resource"/>
                    </a>
                  </td>
                </tr>
              </xsl:if>
              <tr lang="en">
                <th/>
                <td>
                  <xsl:value-of select="rdfs:comment[@xml:lang = 'en']"/>
                </td>
              </tr>
              <tr lang="de">
                <th/>
                <td>
                  <xsl:value-of select="rdfs:comment[@xml:lang = 'de']"/>
                </td>
              </tr>
              <xsl:if test="rdfs:domain">
                <tr>
                  <th>Domain</th>
                  <td>
                    <a href="{rdfs:domain/@rdf:resource}">
                      <xsl:value-of select="rdfs:domain/@rdf:resource"/>
                    </a>
                  </td>
                </tr>
              </xsl:if>
              <xsl:if test="rdfs:range">
                <tr>
                  <th>Range</th>
                  <td>
                    <a href="{rdfs:range/@rdf:resource}">
                      <xsl:value-of select="rdfs:range/@rdf:resource"/>
                    </a>
                  </td>
                </tr>
              </xsl:if>
              <xsl:if test="rdfs:seeAlso">
                <tr>
                  <th>See also</th>
                  <td>
                    <a href="{rdfs:seeAlso/@rdf:resource}">
                      <xsl:value-of select="rdfs:seeAlso/@rdf:resource"/>
                    </a>
                  </td>
                </tr>
              </xsl:if>
            </tbody>
          </table>
        </xsl:for-each>
        <h2>See also</h2>
        <ul>
          <xsl:for-each select="rdf:Description/rdfs:seeAlso">
            <li>
              <a href="{foaf:homepage/@rdf:resource}">
                <xsl:value-of select="dct:title"/>
              </a>
            </li>
          </xsl:for-each>
        </ul>
      </body>
    </html>
  </xsl:template>

</xsl:transform>
