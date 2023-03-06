#!/bin/bash
rm -rf /Users/stephane/Dev/S1000D/HTML/*
java -cp ~/Dev/saxon/saxon-he-11.5.jar net.sf.saxon.Transform -t -s:/Users/stephane/Dev/S1000D/Data/4.1/xml_schema_flat -xsl:/Users/stephane/Dev/S1000D/XSLT/index.xsl -o:/Users/stephane/Dev/S1000D/HTML
for old in /Users/stephane/Dev/S1000D/HTML/*.xml; do mv $old /Users/stephane/Dev/S1000D/HTML/`basename $old .xml`.html; done