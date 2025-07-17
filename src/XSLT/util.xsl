<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    exclude-result-prefixes="xs"
    version="3.0"
    expand-text="yes">

    <xsl:template name="homeNav">
      <p>
        <a href="start_page.html" class="back-home">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M12 5.69L17 10.19V18H15V12H9V18H7V10.19L12 5.69M12 3L2 12H5V20H11V14H13V20H19V12H22" /></svg> Start page
        </a>
      </p>
    </xsl:template>

    <xsl:template name="generateHTMLIndex">
    
    <xsl:result-document href="start_page.html">
      <html lang="en">
      <head>
        <meta charset="UTF-8" />
        <title>List of Schemas</title>
        <xsl:call-template name="author" />
        <link
            rel="stylesheet"
            href="CSS/styles.css" />
      </head>
      <body>
        <header id="top">
          <h1 class="schema__info--title">List of Schemas</h1>
        </header>
        <main>

          <ul class="list__of__schemas">
            <xsl:variable name="collection" select="collection(concat('file:///', $schemasFolder, '/?*.xsd'))"/>

            <xsl:for-each select="$collection">
              <xsl:sort select="substring-after(normalize-space(//xs:annotation/xs:documentation[text()[contains(.,'URL:')]]), 'xml_schema_flat/')" data-type="text" order="ascending"/>
    
              <xsl:variable name="schemaPath" as="xs:string" select="normalize-space(//xs:annotation/xs:documentation[text()[contains(.,'URL:')]])"/>
              <xsl:variable name="fileName" as="xs:string" select="substring-after($schemaPath, 'xml_schema_flat/')"/>

              <li><a href="{$fileName}.html">{$fileName}</a></li>
            </xsl:for-each>
          </ul>

        </main>
        <a href="#top" class="gotop">Top</a>
      </body>
    </html>
    </xsl:result-document>
  </xsl:template>
  
  <xsl:template name="author">
    <meta name="author" content="Stéphane Dubois" />
    <link rel="help" href="https://github.com/frenchysdf/s1000d-schema-viewer" />
    <link rel="icon" type="image/x-icon" href="favicon.ico" />  
  </xsl:template>
</xsl:stylesheet>