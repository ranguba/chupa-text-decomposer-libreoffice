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

require "tempfile"
require "tmpdir"

module ChupaText
  module Decomposers
    class LibreOfficeGeneral < Decomposer
      include Loggable

      def initialize(options)
        super
        @command = find_command
        debug do
          if @command
            "#{log_tag}[command][found] #{@command.path}"
          else
            "#{log_tag}[command][not-found]"
          end
        end
      end

      def target?(data)
        return false if @command.nil?
        @extensions.include?(data.extension) or
          @mime_types.include?(data.mime_type)
      end

      def decompose(data)
        pdf_data = convert_to_pdf(data)
        return if pdf_data.nil?
        yield(pdf_data)
      end

      private
      def find_command
        candidates = [
          @options[:libreoffice],
          ENV["LIBREOFFICE"],
          "libreoffice",
          "soffice",
        ]
        candidates.each do |candidate|
          next if candidate.nil?
          command = ExternalCommand.new(candidate)
          return command if command.exist?
          expanded_candidate = expand_candidate(candidate)
          next if expanded_candidate.nil?
          command = ExternalCommand.new(expanded_candidate)
          return command if command.exist?
        end
        nil
      end

      def expand_candidate(candidate)
        Dir.glob("/opt/libreoffice*/program/#{candidate}").first or
          Dir.glob("C:/Program Files*/libreoffice*/program/#{candidate}.exe").first
      end

      def convert_to_pdf(data)
        Dir.mktmpdir do |temporary_directory|
          home_directory = File.join(temporary_directory, "home")
          FileUtils.mkdir_p(home_directory)
          output_directory = File.join(temporary_directory, "output")
          FileUtils.mkdir_p(output_directory)
          stdout_path = File.join(temporary_directory, "stdout.log")
          stderr_path = File.join(temporary_directory, "stderr.log")
          succeeded = @command.run("--nologo",
                                   "--nolockcheck",
                                   "--norestore",
                                   "--headless",
                                   "--convert-to", "pdf",
                                   "--outdir", output_directory,
                                   data.path.to_s,
                                   {
                                     :data => data,
                                     :env => {
                                       "HOME" => home_directory,
                                     },
                                     :spawn_options => {
                                       :out => stdout_path,
                                       :err => stderr_path,
                                     },
                                   })
          unless succeeded
            error do
              tag = "#{log_tag}[convert][exited][abnormally]"
              [
                tag,
                "output: <#{File.read(stdout_path)}>",
                "error: <#{File.read(stderr_path)}>",
              ].join("\n")
            end
            return nil
          end
          pdf_path, = Dir.glob("#{output_directory}/*.pdf")
          if pdf_path.nil?
            error do
              tag = "#{log_tag}[convert][failed]"
              [
                "#{tag}: LibreOffice may be running",
                "output: <#{File.read(stdout_path)}>",
                "error: <#{File.read(stderr_path)}>",
              ].join("\n")
            end
            return nil
          end
          normalized_pdf_uri = data.uri.to_s.gsub(/\.[^.]+\z/, ".pdf")
          File.open(pdf_path, "rb") do |pdf|
            VirtualFileData.new(normalized_pdf_uri,
                                pdf,
                                :source_data => data)
          end
        end
      end

      def log_tag
        "[decomposer][libreoffice]"
      end
    end
  end
end
