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

module FixtureHelper
  def setup_decomposer
    @decomposer = ChupaText::Decomposers::LibreOffice.new({})
  end

  def fixture_path(*components)
    base_path = Pathname(__FILE__).dirname + "fixture"
    base_path.join(*components)
  end
end

module DecomposeHelper
  def decompose(path)
    data = ChupaText::InputData.new(path)

    pdf_decomposer = ChupaText::Decomposers::PDF.new({})
    decomposed = []
    @decomposer.decompose(data) do |decomposed_data|
      if pdf_decomposer.target?(decomposed_data)
        pdf_decomposer.decompose(decomposed_data) do |pdf_decomposed_data|
          decomposed << pdf_decomposed_data
        end
      else
        decomposed << decomposed_data
      end
    end
    decomposed
  end
end
