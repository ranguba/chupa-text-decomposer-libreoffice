# README

## Name

chupa-text-decomposer-libreoffice-office-open-xml-presentation

## Description

This is a ChupaText decomposer plugin to extract text and meta-data
from Office Open XML Presentation file format file (`.pptx` file used
by Microsoft PowerPoint). This plugin uses
[LibreOffice](https://www.libreoffice.org/).

You can use `libreoffice-office-open-xml-presentation` decomposer.

It depends on `pdf` decomposer. Because it converts a office file to
PDF file and extracts text and meta-data by `pdf` decomposer.

## Install

Install chupa-text-decomposer-libreoffice-office-open-xml-presentation gem:

```
% gem install chupa-text-decomposer-libreoffice-office-open-xml-presentation
```

Install
[LibreOffice from download page](http://www.libreoffice.org/download).

Now, you can extract text and meta-data from office files:

```
% chupa-text slide.pptx
```

## Authors

  * Kouhei Sutou `<kou@clear-code.com>`

  * Shimadzu Corporation

## License

LGPL 2.1 or later.

(Kouhei Sutou has a right to change the license including contributed
patches.)
