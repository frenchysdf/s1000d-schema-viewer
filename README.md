# S1000D Schemas Viewer (🚧 Under construction 🤫)

The purpose of this build process is to be able to go through and read the S1000D XML schemas in a more human friendly way without all the pointy brackets and mental gymnastic required to do so.

### About S1000D

S1000D is an international specification for the production of technical publications. Although the title emphasizes its use for technical publications, application of the specification to non-technical publications is also possible and can be very beneficial to businesses requiring processes and controls. [Official website](https://s1000d.org)

### Requirements

1. Node.js
2. [Java](https://www.java.com/en/) or [OpenjDK](https://openjdk.org/)
3. Saxon (the XSLT parser) which can be downloaded from the [Saxonica website](https://www.saxonica.com/download/download_page.xml) or installed with [homebrew](https://brew.sh) `brew install saxon`.

### Dependencies

1. live-server (Can be installed with `npm install`)

As of now I am using The JAVA version of Saxon but I am planning on using saxonJS in the future which will be a dependency

The S1000D XML Schemas files must be downloaded from the [S1000D website](https://users.s1000d.org/Default.aspx).

### How to transform the schema files to HTML

1. make `transform.sh` script executable `chmod +x path-to-file/file-name`
2. To run the transformation process and use the stylesheets simply run `npm run build` or `./transform.sh` and a browser window will open with the start page.

If you are storing the schema files in a different folder than the data folder run the transform process with a path to the schemas folder: `./transform.sh ~/path-to-schema-folder`

### Caveats

This is an early alpha, it only works with version 4.1 of the S1000D specification.

Some paths are hardcoded in the XSLT but will be passed as parameters or variables to the stylesheet in the future.

The transformation process is done with a bash script (a \*NIX machine is preferred but you can use Git BASH or WSL on Windows). In order to transform the schemas to HTML just run: `./transform.sh` or `npm run build`.

1. The bash script is expected to have Saxon installed and aliased to "saxon" or added to your PATH in .bashrc/.zshrc file.
2. Schemas are expected to be placed in the data folder but you can forek the repository and update the build script in the package.json file with the path to the schemas folder as an argument `./transform.sh ~/path-to-schemas-folder`.

### Folders structure

-- data  
|  
-- dist  
|  
-- src  
|&nbsp;&nbsp;-- CSS  
|&nbsp;&nbsp;-- IMG  
|&nbsp;&nbsp;-- JS  
|&nbsp;&nbsp;-- XSLT
