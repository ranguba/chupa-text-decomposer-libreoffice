# Copyright (C) 2014-2019  Kouhei Sutou <kou@clear-code.com>
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

module XlsxTests
  class << self
    def included(test_case)
      test_case.class_eval do
        include FixtureHelper

        def fixture_path(*components)
          super("xlsx", *components)
        end

        sub_test_case("target?") do
          sub_test_case("extension") do
            def create_data(uri)
              data = ChupaText::Data.new
              data.body = ""
              data.uri = uri
              data
            end

            def test_xlsx
              assert_true(@decomposer.target?(create_data("document.xlsx")))
            end
          end

          sub_test_case("mime-type") do
            def create_data(mime_type)
              data = ChupaText::Data.new
              data.mime_type = mime_type
              data
            end

            def test_openxml_sheet
              mime_type = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
              assert_true(@decomposer.target?(create_data(mime_type)))
            end
          end
        end

        sub_test_case("decompose") do
          include DecomposeHelper

          sub_test_case("attributes") do
            def test_title
              assert_equal(["Title"], decompose("title"))
            end

            def test_author
              assert_equal([nil], decompose("author"))
            end

            def test_subject
              assert_equal(["Subject"], decompose("subject"))
            end

            def test_keywords
              assert_equal(["Keyword1, Keyword2"], decompose("keywords"))
            end

            def test_creator
              assert_equal(["Calc"], decompose("creator"))
            end

            def test_producer
              assert_equal(["LibreOffice X.Y"],
                           normalize_producers(decompose("producer")))
            end

            def test_creation_date
              assert_equal([nil], decompose("creation_date"))
            end

            private
            def decompose(attribute_name)
              super(fixture_path("attributes.xlsx")).collect do |data|
                data[attribute_name]
              end
            end
          end

          sub_test_case("one sheet") do
            def test_body
              assert_equal([<<-BODY], decompose.collect(&:body))
Sheet1 - A1
Sheet1 - A2
Sheet1 - B1
Sheet1 - B2
              BODY
            end

            private
            def decompose
              super(fixture_path("one-sheet.xlsx"))
            end
          end

          sub_test_case("multi sheets") do
            def test_body
              assert_equal([<<-BODY], decompose.collect(&:body))
Sheet1 - A1
Sheet1 - A2
Sheet1 - B1
Sheet1 - B2
Sheet2 - A1
Sheet2 - A2
Sheet2 - B1
Sheet2 - B2
Sheet3 - A1
Sheet3 - A2
Sheet3 - B1
Sheet3 - B2
              BODY
            end

            private
            def decompose
              super(fixture_path("multi-sheets.xlsx"))
            end
          end
        end
      end
    end
  end
end
