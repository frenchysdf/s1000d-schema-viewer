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
                select="normalize-space(//xs:annotation/xs:documentation[text()[contains(.,'URL:')]])"
                as="xs:string" />

  <xsl:variable name="schema"
                select="substring-after($schemaURL, 'xml_schema_flat/')"
                as="xs:string" />

  <xsl:variable name="xlinkSchemaDoc"
                select="document('xlink.xsd')" />

  <xsl:variable name="rdfSchemaDoc"
                select="document('rdf.xsd')" />

  <xsl:variable name="title"
                as="xs:token">
    Schema: {$schema} | S1000D {$issueNumber}
  </xsl:variable>

  <xsl:include href="util.xsl"/>

  <!-- TEMPLATES -->

  <xsl:template match="xs:schema">

    <!-- We generate the startpage -->

    <xsl:call-template name="generateHTMLIndex" />

    <!-- Now we generate the schema page -->

    <html lang="en">
      <head>
        <meta charset="UTF-8" />
        <title>{$title}</title>
        <xsl:call-template name="author" />
        <link
            rel="stylesheet"
            href="CSS/styles.css" />
      </head>
      <body>
        <header id="top">
          <h1 class="schema__info--title">{$title}</h1>
        </header>
        <div class="content__wrapper">
          <nav>
            <xsl:call-template name="homeNav"/>
            <h2>Table of Contents <br/>
            <span class="schema">Schema: {$schema}</span><br/>
            <span class="elements__count">({count(//xs:element[@type])}<xsl:text> elements</xsl:text>)</span></h2>
            <ul class="treeFilter flex" id="treeFilter">
              <!-- 
                  DO NOT add another class to the svg elements in this node, this will break the event listener.
                  [TODO]: Make the event listener more robust [07/16/2025]
              -->
              <li class="flex-1-1 flex-a-i-c flex-j-c-c activeFilter">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" class="treeOrder" alt="Filter by document order">
                  <title>Filter by document order</title>
                  <path d="M3,3H9V7H3V3M15,10H21V14H15V10M15,17H21V21H15V17M13,13H7V18H13V20H7L5,20V9H7V11H13V13Z" />
                </svg>
              </li>
              <li class="flex-1-1">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" class="alphaOrder" alt="Filter by alphabetical order">
                  <title>Filter by alphabetical order</title>
                  <path d="M19 17H22L18 21L14 17H17V3H19M11 13V15L7.67 19H11V21H5V19L8.33 15H5V13M9 3H7C5.9 3 5 3.9 5 5V11H7V9H9V11H11V5C11 3.9 10.11 3 9 3M9 7H7V5H9Z" />
                </svg>
              </li>
            </ul>
            <ul id="toc">
              <xsl:apply-templates select="xs:element"
                                   mode="toc">
                <!-- <xsl:sort select="lower-case(@name)" /> -->
              </xsl:apply-templates>
            </ul>
            <xsl:call-template name="homeNav"/>
          </nav>
          <main>
            <xsl:apply-templates />
          </main>
        </div>
        <a href="start_page.html" class="home"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M12 5.69L17 10.19V18H15V12H9V18H7V10.19L12 5.69M12 3L2 12H5V20H11V14H13V20H19V12H22" /></svg></a>
        <a href="#top" class="gotop">Top</a>
        <script src="JS/index.js"></script>
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
    <xsl:variable name="position" as="xs:positiveInteger">
      <xsl:number />
    </xsl:variable>

    <section id="{$id}">
      <header>
        <h2> Element: {$id} <xsl:if test="$position = 1"> (Root element)</xsl:if></h2>
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
      <h4>Children sequence:</h4>
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

  <!-- Ignored elements or elements processed through other templates -->

  <xsl:template match="xs:import |
                       xs:annotation |
                       xs:complexType |
                       xs:simpleType |
                       xs:attribute |
                       xs:attributeGroup |
                       xs:group" />
</xsl:stylesheet>
