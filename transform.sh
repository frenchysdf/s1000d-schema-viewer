#!/bin/bash
PROJECT_FOLDER_PATH=${1}
#1-Remove all existing HTML files
rm -rf "${PROJECT_FOLDER_PATH}"/HTML/*
#2-Transform Schema files with Saxon and output them in the HTML folder
java -cp "${PROJECT_FOLDER_PATH}"/saxon/saxon-he-11.5.jar net.sf.saxon.Transform -t -s:"${PROJECT_FOLDER_PATH}"/Data/4.1/xml_schema_flat -xsl:"${PROJECT_FOLDER_PATH}"/XSLT/index.xsl -o:"${PROJECT_FOLDER_PATH}"/HTML
#3-Change file extension from XML to HTML
for old in "${PROJECT_FOLDER_PATH}"/HTML/*.xml; do mv $old "${PROJECT_FOLDER_PATH}"/HTML/`basename $old .xml`.html; done