#!/bin/bash

#A - make this script executable `chmod +x path-to-file/file-name`
#B - To run the transformation process and use the stylesheets simply run `npm run build` or `./transform.sh` 
#B2 - If you are storing the schema files in a different folder than the data folder run the transform process with a path to the schemas folder: ./transform.sh ~/path-to-schema-folder

PROJECT_FOLDER_PATH=$PWD
SCHEMAS_FOLDER=${1:-$PROJECT_FOLDER_PATH/data}
SRC_FOLDER=$PROJECT_FOLDER_PATH/src
DIST_FOLDER=$PROJECT_FOLDER_PATH/dist

#1-Protect your neck!
echo "Looking for the data folder and the schemas..."
xsd_files=($(find "$SCHEMAS_FOLDER" -maxdepth 1 -type f -name "*.xsd" -print0 | xargs -0))

if [ ! -d "$SCHEMAS_FOLDER" ] || [ ${#xsd_files[@]} -eq 0 ]; then 
  echo "The data folder is missing or empty, please create this folder, add the schema files or provide an alternative path in the build script section in package.json"; 
  exit
fi

#1-Remove all existing HTML files
echo "Cleaning the dist folder..."
find "$DIST_FOLDER"/. ! -name '.gitignore' -type f -exec rm -rf {} +
find "$DIST_FOLDER"/. -type d  -exec rm -rf {} +

#macOS only
#There is a special place in hell for .DS_Store files
find "${SCHEMAS_FOLDER}"/. -name '.DS_Store' -type f -exec rm -rf {} +

#2-Transform every schema in the schemas folder with saxon installed with homebrew and save them to the dist folder
echo "Transforming the schemas"
saxon -t -s:"${SCHEMAS_FOLDER}" -xsl:"${SRC_FOLDER}/XSLT/index.xsl" -o:"${DIST_FOLDER}" schemasFolder="${SCHEMAS_FOLDER}"

#3-Move the CSS file to the dist folder
echo "Moving the css folder to the dist folder"
cp -r "${SRC_FOLDER}/CSS" "${DIST_FOLDER}"

echo "Moving the javascript folder to the dist folder"
cp -r "${SRC_FOLDER}/JS" "${DIST_FOLDER}"

cp -r "${SRC_FOLDER}/IMG/favicon.ico" "${DIST_FOLDER}"

#4-Change file extension from XML to HTML
echo "Change file extension to .html"
for xmlFile in "${DIST_FOLDER}"/*.xml; do mv "$xmlFile" "${DIST_FOLDER}"/`basename $xmlFile .xml`.html; done

#5-Open the start page
echo "Open the start page"
# open "${PROJECT_FOLDER_PATH}"/dist/start_page.html
cd "${DIST_FOLDER}" && live-server --open=start_page.html

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