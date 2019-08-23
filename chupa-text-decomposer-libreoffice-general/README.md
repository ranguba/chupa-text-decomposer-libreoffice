# README

## Name

chupa-text-decomposer-libreoffice

## Description

This is a ChupaText decomposer plugin for to extract text and
meta-data from office files such as Microsoft Word file, Microsoft
Excel file and OpenDocument Format file. It uses
[LibreOffice](https://www.libreoffice.org/).

You can use `libreoffice` decomposer.

It depends on `pdf` decomposer. Because it converts a office file to
PDF file and extracts text and meta-data by `pdf` decomposer.

## Install

Install chupa-text-decomposer-libreoffice gem:

```
% gem install chupa-text-decomposer-libreoffice
```

Install
[LibreOffice from download page](http://www.libreoffice.org/download).

Now, you can extract text and meta-data from office files:

```
% chupa-text document.doc
```

## Authors

  * Kouhei Sutou `<kou@clear-code.com>`

  * Shimadzu Corporation

## License

LGPL 2.1 or later.

(Kouhei Sutou has a right to change the license including contributed
patches.)
