# -*- ruby -*-
#
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

clean_white_space = lambda do |entry|
  entry.gsub(/(\A\n+|\n+\z)/, '') + "\n"
end

Gem::Specification.new do |spec|
  spec.name = "chupa-text-decomposer-libreoffice-general"
  spec.version = "1.0.1"
  spec.homepage = "https://github.com/ranguba/chupa-text-decomposer-libreoffice"
  spec.authors = ["Kouhei Sutou"]
  spec.email = ["kou@clear-code.com"]
  readme = File.read("README.md", :encoding => "UTF-8")
  entries = readme.split(/^\#\#\s(.*)$/)
  description = clean_white_space.call(entries[entries.index("Description") + 1])
  spec.summary = description.split(/\n\n+/, 2).first
  spec.description = description
  spec.license = "LGPL-2.1+"
  spec.files = ["#{spec.name}.gemspec"]
  spec.files += ["README.md", "LICENSE.txt", "Rakefile", "Gemfile"]
  spec.files += [".yardopts"]
  spec.files += Dir.glob("lib/**/*.rb")
  spec.files += Dir.glob("doc/text/*")
  spec.files += Dir.glob("test/**/*")

  spec.requirements << "LibreOffice"

  spec.add_runtime_dependency("chupa-text", ">= 1.0.9")
  spec.add_runtime_dependency("chupa-text-decomposer-pdf")

  spec.add_development_dependency("bundler")
  spec.add_development_dependency("rake")
  spec.add_development_dependency("test-unit")
  spec.add_development_dependency("packnga")
  spec.add_development_dependency("redcarpet")
end
