<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    exclude-result-prefixes="xs"
    version="3.0">

  <xsl:output
      method="html"
      indent="yes"
      include-content-type="no"
      html-version="5" />

  <xsl:variable
      name="issueNumber"
      select="//xs:annotation/xs:documentation[1]"
      as="xs:string" />
  <xsl:variable
      name="schemaURL"
      select="//xs:annotation/xs:documentation[5]"
      as="xs:string" />
  <xsl:variable
      name="schema"
      select="substring-after($schemaURL, 'xml_schema_flat/')"
      as="xs:string" />

  <xsl:variable
      name="xlinkSchemaDoc"
      select="document('../Data/4.1/xml_schema_flat/xlink.xsd')" />

    <xsl:variable
      name="rdfSchemaDoc"
      select="document('../Data/4.1/xml_schema_flat/rdf.xsd')" />

  
  <xsl:template match="xs:schema">
    <html lang="en">
      <head>
        <meta charset="UTF-8" />
        <title>Schema: <xsl:value-of select="$schema" /> | S1000D <xsl:value-of select="$issueNumber" /></title>
        <link
            rel="stylesheet"
            href="../CSS/styles.css" />
      </head>
      <body>
        <header id="top">
          <h1 class="schema__info--title"> Schema: <xsl:value-of select="$schema" /> | S1000D <xsl:value-of select="$issueNumber" /></h1>
        </header>
        <div class="content__wrapper">
          <nav>
            <h2>Table of Contents</h2>
            <ul>
              <xsl:apply-templates
                  select="xs:element"
                  mode="toc">
                <xsl:sort select="lower-case(@name)" />
              </xsl:apply-templates>
            </ul>
          </nav>
          <main>
            <xsl:apply-templates />
          </main>
        </div>
        <a
            href="#top"
            class="gotop">Top</a>
      </body>
    </html>
  </xsl:template>

  <xsl:template
      match="xs:element"
      mode="toc">

    <xsl:variable
        name="name"
        select="@name"
        as="xs:string" />

    <li>
      <a href="#{$name}">
        <xsl:value-of select="$name" />
      </a>
    </li>

  </xsl:template>

  <xsl:template match="xs:element">

    <xsl:variable
        name="type"
        select="@type"
        as="xs:string" />

    <xsl:variable
        name="id"
        select="@name"
        as="xs:string" />

    <section id="{$id}">
      <header>
        <h2> Element: <xsl:value-of select="$id" /></h2>
      </header>

      <xsl:apply-templates
          select="//*[@name=$type]"
          mode="element-children" />

      <p style="color: green">
        <xsl:value-of select="name(following-sibling::*[1])" />
      </p>
    </section>
  </xsl:template>

  <xsl:template
      match="xs:complexType"
      mode="element-children">

    <xsl:if test="xs:attribute | xs:attributeGroup">
      <article>
        <h4>
          Attributes</h4>
        <ul>
          <xsl:apply-templates
              select="xs:attribute | xs:attributeGroup"
              mode="attribute" />
        </ul>
      </article>
    </xsl:if>

    <xsl:apply-templates select="xs:sequence" />

    <ul>
      <xsl:for-each select="*[not(self::xs:sequence | self::xs:attribute)]">
        <li>
          <xsl:value-of select="name()" />
        </li>
      </xsl:for-each>
    </ul>
  </xsl:template>

  <xsl:template
      match="xs:attribute"
      mode="attribute">
    <li>
      <xsl:value-of select="@ref, if (exists(@use)) then concat(' (', @use, ')') else ''" />
    </li>
  </xsl:template>

    <xsl:template
      match="xs:attributeGroup"
      mode="attribute">

    <xsl:variable
        name="attributeGroup"
        select="@ref" />

    <xsl:apply-templates
        select="//xs:attributeGroup[@name = $attributeGroup]/xs:attribute"
        mode="attribute" />

    <!-- <xsl:apply-templates /> -->

  </xsl:template>

  <xsl:template match="xs:sequence">
    <article>
      <h4 style="color: red">Children
        sequence:</h4>
      <ul>
        <xsl:apply-templates
            select="xs:element"
            mode="sequence" />
      </ul>
      <ul>
        <xsl:for-each select="*[not(self::xs:element)]">
          <li>
            <xsl:value-of select="name()" />
          </li>
        </xsl:for-each>
      </ul>
    </article>
  </xsl:template>

  <xsl:template
      match="xs:element"
      mode="sequence">
    <li>
      <a href="#{@ref}">
        <xsl:value-of select="@ref" />
      </a>
      <xsl:if test="@minOccurs = 0">
        <xsl:text> (optional)</xsl:text>
      </xsl:if>
    </li>
  </xsl:template>

  <xsl:template match="*">
    <p class="error"> The element <xsl:value-of select="name()" /> does not have a template </p>
  </xsl:template>

  <xsl:template match="xs:import | 
                       xs:annotation | 
                       xs:complexType | 
                       xs:simpleType | 
                       xs:attribute | 
                       xs:attributeGroup | 
                       xs:group">
    <!-- Silence is golden -->
  </xsl:template>

</xsl:stylesheet>