<p:declare-step version="1.0" name="emblem2rdf"
                xmlns:emblem="http://diglib.hab.de/rules/schema/emblem"
                xmlns:embrdf="http://uri.hab.de/ontology/emblem#"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:cx="http://xmlcalabash.com/ns/extensions"
                xmlns:c="http://www.w3.org/ns/xproc-step"
                xmlns:e="http://emblem2rdf.org/ns/xproc"
                xmlns:h="http://www.w3.org/1999/xhtml"
                xmlns:p="http://www.w3.org/ns/xproc">

  <p:documentation xmlns="http://www.w3.org/1999/xhtml">
    This pipeline reads one or more emblem book descriptions, encoded in <a href="http://diglib.hab.de/rules/schema/emblem">Emblem Schema</a> and
    creates emblem descriptions modelled after the <a href="http://uri.hab.de/ontology/emblem">Wolfenbüttel Core Emblem Ontology</a>.
  </p:documentation>

  <p:input  port="source" primary="true" sequence="true"/>
  <p:output port="result" primary="true" sequence="true"/>
  <p:output port="beacon" sequence="false">
    <p:pipe step="make-beacon" port="result"/>
  </p:output>

  <p:option name="errors"  required="false" select="''"/>
  <p:option name="emblems" required="false" select="''"/>

  <p:import href="http://xmlcalabash.com/extension/steps/library-1.0.xpl"/>

  <p:declare-step type="e:validate-skip">
    <p:documentation>
      Validate emblem descriptions and remove those that are invalid.
    </p:documentation>
    <p:input  port="source" primary="true" sequence="true"/>
    <p:output port="result" primary="true" sequence="true"/>
    <p:option name="errors" required="false" select="''"/>

    <p:viewport match="emblem:biblioDesc">
      <p:variable name="recordId" select="emblem:biblioDesc/*:mods/*:recordInfo/*:recordIdentifier"/>
      <p:try name="validate">
        <p:group>
          <p:validate-with-xml-schema assert-valid="true">
            <p:input port="schema">
              <p:document href="../schema/emblem/emblem-1-3.xsd"/>
            </p:input>
          </p:validate-with-xml-schema>
        </p:group>
        <p:catch name="catch">
          <p:identity>
            <p:input port="source">
              <p:pipe step="catch" port="error"/>
            </p:input>
          </p:identity>
        </p:catch>
      </p:try>

     <p:choose>
       <p:when test="($errors != '') and /c:errors">
         <cx:message>
           <p:with-option name="message" select="concat('Validation error PPN ', $recordId)"/>
         </cx:message>
         <p:store method="xml">
           <p:with-option name="href" select="concat($errors, '.', $recordId)"/>
         </p:store>
         <p:identity>
           <p:input port="source">
             <p:inline>
               <skip/>
             </p:inline>
           </p:input>
         </p:identity>
       </p:when>
       <p:otherwise>
         <p:identity/>
       </p:otherwise>
     </p:choose>
    </p:viewport>

  </p:declare-step>

  <p:declare-step type="e:transform-emblems">
    <p:documentation>
      Replace all emblem descriptions with the corresponding RDF/XML serialization.
    </p:documentation>
    <p:input  port="source" primary="true" sequence="true"/>
    <p:output port="result" primary="true" sequence="true"/>

    <p:viewport match="emblem:emblem">
      <cx:message>
        <p:with-option name="message" select="emblem:emblem/@globalID"/>
      </cx:message>
      <p:xslt>
        <p:input port="stylesheet">
          <p:document href="../xslt/emblem2rdf.xsl"/>
        </p:input>
        <p:input port="parameters">
          <p:empty/>
        </p:input>
      </p:xslt>

      <p:validate-with-relax-ng>
        <p:input port="schema">
          <p:data href="../schema/emblem2rdf.rnc"/>
        </p:input>
      </p:validate-with-relax-ng>
    </p:viewport>

  </p:declare-step>

  <p:declare-step type="e:emblembook-metadata" name="emblembook-metadata">
    <p:documentation>
      Augment each emblem with statements about the containing emblem book, if possible.
    </p:documentation>
    <p:input  port="source" primary="true" sequence="true"/>
    <p:output port="result" primary="true" sequence="true"/>

    <p:viewport match="emblem:biblioDesc" name="iterate-emblembooks">
      <p:viewport-source>
        <p:pipe step="emblembook-metadata" port="source"/>
      </p:viewport-source>

      <p:xslt name="emblembook">
        <p:input port="stylesheet">
          <p:document href="../xslt/emblembook2rdf.xsl"/>
        </p:input>
        <p:input port="parameters">
          <p:empty/>
        </p:input>
      </p:xslt>

      <p:insert position="last-child" match="embrdf:Emblem" name="insert">
        <p:input port="source">
          <p:pipe step="iterate-emblembooks" port="current"/>
        </p:input>
        <p:input port="insertion">
          <p:pipe step="emblembook" port="result"/>
        </p:input>
      </p:insert>

      <p:xslt>
        <p:input port="source">
          <p:pipe step="insert" port="result"/>
        </p:input>
        <p:input port="stylesheet">
          <p:document href="../xslt/pushdown.xsl"/>
        </p:input>
        <p:input port="parameters">
          <p:empty/>
        </p:input>
      </p:xslt>

    </p:viewport>

  </p:declare-step>

  <p:declare-step type="e:store-emblem-instances" name="store-emblem-instances">
    <p:documentation>
      Store RDF/XML and HTML for each emblem instance.
    </p:documentation>

    <p:input  port="source" primary="true" sequence="true"/>

    <p:option name="targetBaseDir" required="true"/>

    <p:for-each name="iterate">
      <p:iteration-source select="//rdf:RDF[embrdf:Emblem[starts-with(@rdf:about, 'http://hdl.handle.net/10111/EmblemRegistry:')]]"/>
      <p:variable name="emblemId" select="substring(/rdf:RDF/embrdf:Emblem/@rdf:about, 44)"/>
      <p:variable name="basename" select="concat($targetBaseDir, '/', $emblemId)"/>

      <p:xslt name="rdf2html">
        <p:input port="source">
          <p:pipe step="iterate" port="current"/>
        </p:input>
        <p:input port="stylesheet">
          <p:document href="../xslt/rdf2html.xsl"/>
        </p:input>
        <p:input port="parameters">
          <p:empty/>
        </p:input>
      </p:xslt>

      <p:store method="html" omit-xml-declaration="true" version="4.0">
        <p:with-option name="href" select="concat($basename, '.html')"/>
        <p:input port="source">
          <p:pipe step="rdf2html" port="result"/>
        </p:input>
      </p:store>

      <p:store method="xml">
        <p:with-option name="href" select="concat($basename, '.rdf')"/>
        <p:input port="source">
          <p:pipe step="iterate" port="current"/>
        </p:input>
      </p:store>
    </p:for-each>

  </p:declare-step>

  <e:validate-skip name="validate-source">
    <p:with-option name="errors" select="$errors"/>
    <p:input port="source">
      <p:pipe step="emblem2rdf" port="source"/>
    </p:input>
  </e:validate-skip>

  <e:transform-emblems name="transform-emblems">
    <p:input port="source">
      <p:pipe step="validate-source" port="result"/>
    </p:input>
  </e:transform-emblems>

  <e:emblembook-metadata name="emblembook-metadata">
    <p:input port="source">
      <p:pipe step="transform-emblems" port="result"/>
    </p:input>
  </e:emblembook-metadata>

  <p:choose>
    <p:when test="$emblems != ''">
      <e:store-emblem-instances>
        <p:with-option name="targetBaseDir" select="$emblems"/>
        <p:input port="source">
          <p:pipe step="emblembook-metadata" port="result"/>
        </p:input>
      </e:store-emblem-instances>
    </p:when>
    <p:otherwise>
      <p:sink/>
    </p:otherwise>
  </p:choose>

  <p:wrap-sequence wrapper="rdf:RDF" name="wrap-emblems">
    <p:input port="source" select="//rdf:RDF/*">
      <p:pipe step="emblembook-metadata" port="result"/>
    </p:input>
  </p:wrap-sequence>

  <p:xslt name="make-beacon">
    <p:input port="source">
      <p:pipe step="wrap-emblems" port="result"/>
    </p:input>
    <p:input port="stylesheet">
      <p:document href="../xslt/beacon.xsl"/>
    </p:input>
    <p:input port="parameters">
      <p:empty/>
    </p:input>
  </p:xslt>

  <p:identity>
    <p:input port="source">
      <p:pipe step="wrap-emblems" port="result"/>
    </p:input>
  </p:identity>

</p:declare-step>
