# S1000D Schema Viewer

Under construction 🤫

The purpose of this build process is to be able to go through and read the S1000D XML schemas in a more human friendly way without all the pointy brackets and mental gymnastic required to do so.

### About S1000D

S1000D is an international specification for the production of technical publications. Although the title emphasizes its use for technical publications, application of the specification to non-technical publications is also possible and can be very beneficial to businesses requiring processes and controls.

### Requirements

[Java](https://www.java.com/en/) or [OpenjDK](https://openjdk.org/) for the Java version
Saxon (the XSLT parser) can be downloaded on the [Saxonica](https://www.saxonica.com/download/download_page.xml) website or installed with [homebrew](https://brew.sh) `brew install saxon`.

The JAVA version is used during the development of the stylesheets but the option to use saxonJS will be offered in the future and will be available as a simple `npm install` option.

The S1000D XML Schemas files must be downloaded from the [S1000D website](https://users.s1000d.org/Default.aspx).

### Caveats

This is an early alpha, it only works with version 4.1 of the S1000D specification.

Some paths are hardcoded in the XSLT but will be passed as parameters or variables to the stylesheet in the future.

The transformation process is done with a bash script (a \*NIX machine is preferred but you can use Git BASH or WSL on Windows). In order to transform the schemas to HTML just run: `./transform.sh` or `npm run build`.

1. The bash script is expected to have saxon installed and aliased to "saxon" or added to your PATH in .bashrc/.zshrc file.
2. Schemas are expected to be placed in the data folder but the option to pass the path as a variable is in the work.

Folders structure:

-- data  
&nbsp;&nbsp;&nbsp;&nbsp;| -- 4-1  
&nbsp;&nbsp;&nbsp;&nbsp;| -- 4-2  
|  
-- dist
|  
-- src
&nbsp;&nbsp;&nbsp;&nbsp;| -- xslt
&nbsp;&nbsp;&nbsp;&nbsp;| -- css
