#!/bin/bash
#run the stylesheet: ./transform.sh ~/Dev/S1000D ~/Dev/S1000D/Data/4.1/xml_schema_flat
PROJECT_FOLDER_PATH=${1}
SCHEMA_FOLDER=${2}
#1-Remove all existing HTML files
rm -rf "${PROJECT_FOLDER_PATH}"/HTML/*
#2-Transform Schema files with Saxon and output them in the HTML folder | We use the java version of Saxon for now but should move to Saxon JS so we can replace this bash script with npm scripts
java -cp "${PROJECT_FOLDER_PATH}"/saxon/saxon-he-11.5.jar net.sf.saxon.Transform -t -s:"${SCHEMA_FOLDER}" -xsl:"${PROJECT_FOLDER_PATH}"/XSLT/index.xsl -o:"${PROJECT_FOLDER_PATH}"/HTML schemasFolder="${SCHEMA_FOLDER}"
#3-Change file extension from XML to HTML
for old in "${PROJECT_FOLDER_PATH}"/HTML/*.xml; do mv $old "${PROJECT_FOLDER_PATH}"/HTML/`basename $old .xml`.html; done