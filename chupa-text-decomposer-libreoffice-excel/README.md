# README

## Name

chupa-text-decomposer-libreoffice-excel

## Description

This is a ChupaText decomposer plugin to extract text and meta-data
from Microsoft Excel binary file format file (`.xls` file). This plugin
uses [LibreOffice](https://www.libreoffice.org/).

You can use `libreoffice-excel` decomposer.

It depends on `pdf` decomposer. Because it converts a office file to
PDF file and extracts text and meta-data by `pdf` decomposer.

## Install

Install chupa-text-decomposer-libreoffice-excel gem:

```
% gem install chupa-text-decomposer-libreoffice-excel
```

Install
[LibreOffice from download page](http://www.libreoffice.org/download).

Now, you can extract text and meta-data from office files:

```
% chupa-text workbook.xls
```

## Authors

  * Kouhei Sutou `<kou@clear-code.com>`

  * Shimadzu Corporation

## License

LGPL 2.1 or later.

(Kouhei Sutou has a right to change the license including contributed
patches.)
