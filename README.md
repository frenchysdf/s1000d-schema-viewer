# S1000D Schema Viewer

Under construction 🤫

## About S1000D

S1000D is an international specification for the production of technical publications. Although the title emphasizes its use for technical publications, application of the 
specification to non-technical publications is also possible and can be very beneficial to businesses requiring processes and controls.

### Requirements

You will need to download Saxon (the XSLT parser) from [Saxonica](https://www.saxonica.com/download/download_page.xml); I personally use the JAVA version but might move to 
the JavaScript version at some point.

The S1000D XML Schemas files can be downloaded from the [S1000D website](https://users.s1000d.org/ProductList.aspx)

The process is ran by a bash file so a *NIX machine is prefered but you can use Git BASH or WSL on Windows. 

#### Caveats

This is an early alpha, it only works with version 4.1 of the S1000D specification. 

The transformation process is done with a bash script. To transform the schemas to HTML just run: ./transform.sh ~/Dev/S1000D 
~/Dev/S1000D/Data/4.1/xml_schema_flat

1. The first argument is the path to project folder
2. The second argument is the path to the XML schemas

Folders structure:

-- CSS
-- Data
-- HTML
-- saxon
-- XSLT
