# -*- ruby -*-
#
# Copyright (C) 2019  Kouhei Sutou <kou@clear-code.com>
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

task :default => :test

desc "Run tests"
task :test do
  FileList["*/test/run-test.rb"].each do |run_test_rb|
    cd(Pathname(run_test_rb).parent.parent) do
      ruby("test/run-test.rb")
    end
  end
end

desc "Release"
task :release do
  FileList["*/*.gemspec"].each do |gemspec|
    cd(Pathname(gemspec).parent) do
      ruby("-S", "rake", "release")
    end
  end
end
