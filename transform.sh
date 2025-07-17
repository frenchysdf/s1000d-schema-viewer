#!/bin/bash

#A - make this script executable `chmod +x path-to-file/file-name`
#B - To run the transformation process and use the stylesheets simply run `npm run build` or `./transform.sh` 
#B2 - If you are storing the schema files in a different folder than the data folder run the transform process with a path to the schemas folder: ./transform.sh ~/path-to-schema-folder

PROJECT_FOLDER_PATH=$PWD
SCHEMAS_FOLDER=${1:-$PROJECT_FOLDER_PATH/data}

#1-Remove all existing HTML files
echo "Cleaning the dist folder..."
find "$PROJECT_FOLDER_PATH"/dist/. ! -name '.gitignore' -type f -exec rm -rf {} +

#macOS only
#There is a special place in hell for .DS_Store files
find "$PROJECT_FOLDER_PATH"/data/. -name '.DS_Store' -type f -exec rm -rf {}

#2-Transform every schema in the schemas folder with saxon installed with homebrew and save them to the dist folder
echo "Transforming the schemas"
saxon -t -s:"${PROJECT_FOLDER_PATH}"/data -xsl:"${PROJECT_FOLDER_PATH}"/src/XSLT/index.xsl -o:"${PROJECT_FOLDER_PATH}"/dist schemasFolder="${SCHEMAS_FOLDER}"

#3-Move the CSS file to the dist folder
echo "Moving the css folder to the dist folder"
cp -r "${PROJECT_FOLDER_PATH}/"src/CSS "${PROJECT_FOLDER_PATH}"/dist

echo "Moving the javascript folder to the dist folder"
cp -r "${PROJECT_FOLDER_PATH}"/src/JS "${PROJECT_FOLDER_PATH}"/dist

#4-Change file extension from XML to HTML
echo "Change file extension to .html"
for xmlFile in "${PROJECT_FOLDER_PATH}"/dist/*.xml; do mv "$xmlFile" "${PROJECT_FOLDER_PATH}"/dist/`basename $xmlFile .xml`.html; done

#5-Open the start page
echo "Open the start page"
# open "${PROJECT_FOLDER_PATH}"/dist/start_page.html
cd "${PROJECT_FOLDER_PATH}"/dist && live-server --open=start_page.html

## Keep the content below for documentation and alternative use

#2-Transform the Schema files with Saxon downloaded from the Saxonica website 
#echo "Transforming the schemas"
#java -cp "${PROJECT_FOLDER_PATH}"/saxon/saxon-he-11.5.jar net.sf.saxon.Transform -t -s:"${SCHEMAS_FOLDER}" -xsl:"${PROJECT_FOLDER_PATH}"/XSLT/index.xsl -o:"${PROJECT_FOLDER_PATH}"/dist schemasFolder="${SCHEMAS_FOLDER}"

#2-Transform Schema files with saxonJS
#Caveats: saxonJS cannot iterate through a directory so we need to create a for loop in this bash file [TODO] to iterate through the schemas folder

#saxonJS installed as a dev dependency 
#npx xslt3 -s:"${SCHEMAS_FOLDER}" -xsl:"${PROJECT_FOLDER_PATH}"/XSLT/index.xsl -o:"${PROJECT_FOLDER_PATH}"/dist schemasFolder="${SCHEMAS_FOLDER}" -t

#saxonJS installed globally
# xslt3 -s:"${SCHEMAS_FOLDER}" -xsl:"${PROJECT_FOLDER_PATH}"/XSLT/index.xsl -o:"${PROJECT_FOLDER_PATH}"/dist schemasFolder="${SCHEMAS_FOLDER}" -t