# Copyright (C) 2014-2017  Kouhei Sutou <kou@clear-code.com>
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA

require "chupa-text/decomposers/libreoffice-general"

module ChupaText
  module Decomposers
    class LibreOffice < LibreOfficeGeneral
      registry.register("libreoffice", self)

      def initialize(options)
        super
        @extensions = [
          "odt",
          "ods",
          "odp",
          "doc",
          "xls",
          "ppt",
          "docx",
          "xlsx",
          "pptx",
        ]
        @mime_types = [
          "application/vnd.oasis.opendocument.text",
          "application/vnd.oasis.opendocument.presentation",
          "application/vnd.oasis.opendocument.spreadsheet",
          "application/msword",
          "application/vnd.ms-excel",
          "application/vnd.ms-powerpoint",
          "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
          "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
          "application/vnd.openxmlformats-officedocument.presentationml.presentation",
        ]
      end
    end
  end
end
