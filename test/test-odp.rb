# -*- coding: utf-8 -*-
#
# Copyright (C) 2014  Kouhei Sutou <kou@clear-code.com>
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

require "pathname"

class TestOdp < Test::Unit::TestCase
  include FixtureHelper

  def setup
    setup_decomposer
  end

  def fixture_path(*components)
    super("odp", *components)
  end

  sub_test_case("target?") do
    sub_test_case("extension") do
      def create_data(uri)
        data = ChupaText::Data.new
        data.body = ""
        data.uri = uri
        data
      end

      def test_odp
        assert_true(@decomposer.target?(create_data("document.odp")))
      end
    end

    sub_test_case("mime-type") do
      def create_data(mime_type)
        data = ChupaText::Data.new
        data.mime_type = mime_type
        data
      end

      def test_opendocument_presentation
        mime_type = "application/vnd.oasis.opendocument.presentation"
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
        assert_equal(["Impress"], decompose("creator"))
      end

      def test_producer
        assert_equal(["LibreOffice X.Y"],
                     normalize_producer(decompose("producer")))
      end

      def test_creation_date
        assert_equal([nil], decompose("creation_date"))
      end

      private
      def decompose(attribute_name)
        super(fixture_path("attributes.odp")).collect do |data|
          data[attribute_name]
        end
      end
    end

    sub_test_case("one slide") do
      def test_body
        assert_equal([<<-BODY], decompose.collect(&:body))
Slide1 title
Slide1 content
        BODY
      end

      private
      def decompose
        super(fixture_path("one-slide.odp"))
      end
    end

    sub_test_case("multi slides") do
      def test_body
        assert_equal([<<-BODY], decompose.collect(&:body))
Slide1 title
Slide1 content
Slide2 title
●
Slide2 content
Slide3 title
●
Slide3 content
        BODY
      end

      private
      def decompose
        super(fixture_path("multi-slides.odp"))
      end
    end
  end
end
