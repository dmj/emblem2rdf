<xsl:transform version="2.0"
               exclude-result-prefixes="#all"
               xmlns:eg="http://dmaus.name/ns/egxml"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:function name="eg:example">
    <xsl:param name="root" as="node()*"/>
    <xsl:for-each select="$root">
      <xsl:choose>
        <xsl:when test="self::element()"><xsl:copy-of select="eg:element(.)"/></xsl:when>
        <xsl:when test="self::text()"><xsl:value-of select="."/></xsl:when>
        <xsl:when test="self::comment()"><xsl:copy-of select="eg:comment(.)"/></xsl:when>
        <xsl:when test="self::processing-instruction()"><xsl:copy-of select="eg:pi(.)"/></xsl:when>
      </xsl:choose>
    </xsl:for-each>
  </xsl:function>

  <xsl:function name="eg:element" as="element()">
    <xsl:param name="element" as="element()"/>
    <span class="egxml-element">
      <xsl:text>&lt;</xsl:text>
      <span class="egxml-element-name">
        <xsl:value-of select="name($element)"/>
      </span>
      <xsl:for-each select="$element/@*">
        <xsl:text> </xsl:text>
        <xsl:copy-of select="eg:attribute(.)"/>
      </xsl:for-each>
      <xsl:choose>
        <xsl:when test="$element/node()">
          <xsl:text>&gt;</xsl:text>
          <xsl:copy-of select="eg:example($element/node())"/>
          <xsl:text>&lt;/</xsl:text>
          <span class="egxml-element-name">
            <xsl:value-of select="name($element)"/>
          </span>
          <xsl:text>&gt;</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>/&gt;</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </span>
  </xsl:function>

  <xsl:function name="eg:attribute" as="element()">
    <xsl:param name="attribute" as="attribute()"/>
    <span class="egxml-attribute">
      <span class="egxml-attribute-name">
        <xsl:value-of select="name($attribute)"/>
      </span>
      <xsl:text>="</xsl:text>
      <span class="egxml-attribute-value">
        <xsl:value-of select="$attribute"/>
      </span>
      <xsl:text>"</xsl:text>
    </span>
  </xsl:function>

  <xsl:function name="eg:comment" as="element()">
    <xsl:param name="comment" as="comment()"/>
    <span class="egxml-comment">
      <xsl:text>&lt;--</xsl:text>
      <xsl:value-of select="$comment"/>
      <xsl:text>--&gt;</xsl:text>
    </span>
  </xsl:function>

  <xsl:function name="eg:pi" as="element()">
    <xsl:param name="pi" as="processing-instruction()"/>
    <span class="egxml-pi">
      <xsl:text>&lt;? </xsl:text>
      <xsl:value-of select="$pi"/>
      <xsl:text>?&gt;</xsl:text>
    </span>
  </xsl:function>

</xsl:transform>
