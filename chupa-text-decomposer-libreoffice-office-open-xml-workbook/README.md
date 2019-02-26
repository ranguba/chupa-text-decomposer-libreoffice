# README

## Name

chupa-text-decomposer-libreoffice-office-open-xml-workbook

## Description

This is a ChupaText decomposer plugin to extract text and meta-data
from Office Open XML Workbook file format file (`.xlsx` file used by
Microsoft Excel). This plugin uses
[LibreOffice](https://www.libreoffice.org/).

You can use `libreoffice-office-open-xml-workbook` decomposer.

It depends on `pdf` decomposer. Because it converts a office file to
PDF file and extracts text and meta-data by `pdf` decomposer.

## Install

Install chupa-text-decomposer-libreoffice-office-open-xml-workbook gem:

```
% gem install chupa-text-decomposer-libreoffice-office-open-xml-workbook
```

Install
[LibreOffice from download page](http://www.libreoffice.org/download).

Now, you can extract text and meta-data from office files:

```
% chupa-text workbook.xlsx
```

## Author

  * Kouhei Sutou `<kou@clear-code.com>`

## License

LGPL 2.1 or later.

(Kouhei Sutou has a right to change the license including contributed
patches.)