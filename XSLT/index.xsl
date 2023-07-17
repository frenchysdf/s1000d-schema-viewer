<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    exclude-result-prefixes="xs"
    version="3.0"
    expand-text="yes">

  <xsl:output
      method="html"
      indent="yes"
      include-content-type="no"
      html-version="5" />

  <!-- 
  TODO
  Rewrite complexType template best exemple is xs:element applic
  <xs:complexType name="applicElemType">
    <xs:choice>
        <xs:sequence>
            <xs:element ref="displayText"/>
            <xs:choice minOccurs="0">
                <xs:element ref="assert"/>
                <xs:element ref="evaluate"/>
            </xs:choice>
        </xs:sequence>
        <xs:choice>
            <xs:element ref="assert"/>
            <xs:element ref="evaluate"/>
        </xs:choice>
    </xs:choice>
    <xs:attribute ref="applicConfiguration"/>
    <xs:attribute ref="id"/>
    <xs:attributeGroup ref="changeAttGroup"/>
    <xs:attributeGroup ref="securityAttGroup"/>
  </xs:complexType>
  -->

  <!-- Parameters -->

  <xsl:param name="schemasFolder" />

  <!-- Global variables -->

  <xsl:variable name="issueNumber"
                select="//xs:annotation/xs:documentation[1]"
                as="xs:string" />

  <xsl:variable name="schemaURL"
                select="//xs:annotation/xs:documentation[5]"
                as="xs:string" />

  <xsl:variable name="schema"
                select="substring-after($schemaURL, 'xml_schema_flat/')"
                as="xs:string" />

  <xsl:variable name="xlinkSchemaDoc"
                select="document('../Data/4.1/xml_schema_flat/xlink.xsd')" />

  <xsl:variable name="rdfSchemaDoc"
                select="document('../Data/4.1/xml_schema_flat/rdf.xsd')" />

  <xsl:variable name="title" 
                as="xs:token">
    Schema: {$schema} | S1000D {$issueNumber}
  </xsl:variable>

  <!-- TEMPLATES -->

  <xsl:template match="xs:schema">

    <!-- We generate the startpage -->

    <xsl:call-template name="generateHTMLIndex" />

    <!-- Now we generate the shema page -->

    <html lang="en">
      <head>
        <meta charset="UTF-8" />
        <title>{$title}</title>
        <link
            rel="stylesheet"
            href="../CSS/styles.css" />
      </head>
      <body>
        <header id="top">
          <h1 class="schema__info--title">{$title}</h1>
        </header>
        <div class="content__wrapper">
          <nav>
            <h2>Table of Contents</h2>
            <h3>({count(//xs:element[@type])}<xsl:text> elements</xsl:text>)</h3>
            <ul>
              <xsl:apply-templates select="xs:element"
                                   mode="toc">
                <xsl:sort select="lower-case(@name)" />
              </xsl:apply-templates>
            </ul>
          </nav>
          <main>
            <xsl:apply-templates />
          </main>
        </div>
        <a href="start_page.html" class="home"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M12 5.69L17 10.19V18H15V12H9V18H7V10.19L12 5.69M12 3L2 12H5V20H11V14H13V20H19V12H22" /></svg></a>
        <a href="#top" class="gotop">Top</a>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="xs:element"
                mode="toc">

    <xsl:variable
        name="name"
        select="@name"
        as="xs:string" />

    <li>
      <a href="#{$name}">
        {$name}
      </a>
    </li>

  </xsl:template>

  <xsl:template match="xs:element">

    <xsl:variable name="type"
                  select="@type"/>
        <!-- as="xs:string"  -->

    <xsl:variable name="id"
                  select="@name"
                  as="xs:string" />

    <section id="{$id}">
      <header>
        <h2> Element: {$id} /></h2>
      </header>

      <xsl:apply-templates select="//*[@name=$type]"
                           mode="element-children" />

      <p style="color: green">
        <xsl:value-of select="name(//*[@name=$type])" />
      </p>
    </section>
  </xsl:template>

  <xsl:template match="xs:complexType"
                mode="element-children">

    <xsl:if test="xs:attribute | xs:attributeGroup">
      <article>
        <h4>Attributes</h4>
        <ul>
          <xsl:apply-templates select="xs:attribute | xs:attributeGroup"
                               mode="attribute" />
        </ul>
      </article>
    </xsl:if>

    <xsl:apply-templates />

    <ul>
      <xsl:for-each select="*[not(self::xs:sequence | self::xs:attribute  | self::xs:attributeGroup)]">
        <li>
          <xsl:value-of select="name()" />
        </li>
      </xsl:for-each>
    </ul>
  </xsl:template>

  <xsl:template match="xs:attribute"
                mode="attribute">
    <li>
      <xsl:value-of select="@ref, if (exists(@use)) then concat(' (', @use, ')') else ''" />
    </li>
  </xsl:template>

    <xsl:template match="xs:attributeGroup"
                  mode="attribute">

    <xsl:variable
        name="attributeGroup"
        select="@ref" />

    <xsl:apply-templates select="//xs:attributeGroup[@name = $attributeGroup]/xs:attribute"
                         mode="attribute" />

  </xsl:template>

  <xsl:template match="xs:sequence | xs:choice">
    <article>
      <h4 style="color: red">Children sequence:</h4>
      <ul>
        <xsl:apply-templates mode="sequence" />
      </ul>
      <!-- Catch children with no template -->
      <xsl:for-each select="*[not(self::xs:element)]">
        <p class="error">
          <xsl:value-of select="name()" />
        </p>
      </xsl:for-each>

    </article>
  </xsl:template>

  <xsl:template match="xs:element"
                mode="sequence">
    <li>
      <a href="#{@ref}">{@ref}</a>
      <xsl:if test="@minOccurs = 0">
        <xsl:text> (optional)</xsl:text>
      </xsl:if>
    </li>
  </xsl:template>

  <xsl:template match="xs:choice"
                mode="sequence">
    <li>
      <xsl:apply-templates mode="choice" />
    </li>
  </xsl:template>

  <xsl:template match="xs:element"
                mode="choice">
    <xsl:variable name="elementCounter">
      <xsl:number
          count="xs:element"
          from="xs:choice"
          level="single" />
    </xsl:variable>
    
    <xsl:choose>
      <xsl:when test="$elementCounter = 1"><xsl:text>Choice: </xsl:text></xsl:when>
      <xsl:otherwise><xsl:text> OR </xsl:text></xsl:otherwise>
    </xsl:choose>
  
    <a href="#{@ref}">{@ref}</a>
  </xsl:template>

  <!-- Catch all template -->

  <xsl:template match="*">
    <p class="error"> The element <xsl:value-of select="name()" /> does not have a template </p>
  </xsl:template>

  <xsl:template name="generateHTMLIndex">
    <!-- None tech people do not know about index.html being the first file to open so we give them a clue where to start-->
    <xsl:result-document href="start_page.html">
      <html lang="en">
      <head>
        <meta charset="UTF-8" />
        <title>List of Schemas</title>
        <link
            rel="stylesheet"
            href="../CSS/styles.css" />
      </head>
      <body>
        <header id="top">
          <h1 class="schema__info--title">List of Schemas</h1>
        </header>
        <main>

          <ul class="list__of__schemas">
            <xsl:for-each select="collection(concat('file:///', $schemasFolder, '/?*.xsd'))">
            <!-- I really don't like to depend on a predicate position, this is hacky but need it for now until I have more time to think about it -->
              <xsl:variable name="schemaPath" as="xs:string" select="normalize-space(//xs:annotation/xs:documentation[5])"/>
              <xsl:variable name="fileName" select="substring-after($schemaPath, 'xml_schema_flat/')"/>
            
              <li><a href="{$fileName}.html">{$fileName}</a></li>
            </xsl:for-each>
          </ul>

        </main>
        <a href="#top" class="gotop">Top</a>
      </body>
    </html>
    </xsl:result-document>
  </xsl:template>

  <!-- Ignored elements or elements processed through other templates -->

  <xsl:template match="xs:import | 
                       xs:annotation | 
                       xs:complexType | 
                       xs:simpleType | 
                       xs:attribute | 
                       xs:attributeGroup | 
                       xs:group" />
</xsl:stylesheet>