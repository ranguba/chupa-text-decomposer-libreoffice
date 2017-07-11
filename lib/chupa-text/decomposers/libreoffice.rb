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

require "tempfile"
require "tmpdir"

module ChupaText
  module Decomposers
    class LibreOffice < Decomposer
      include Loggable

      registry.register("libreoffice", self)

      def initialize(options)
        super
        @command = find_command
        debug do
          if @command
            "#{log_tag}[command][found] #{@command}"
          else
            "#{log_tag}[command][not-found]"
          end
        end
      end

      TARGET_EXTENSIONS = [
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
      TARGET_MIME_TYPES = [
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
      def target?(data)
        return false if @command.nil?
        TARGET_EXTENSIONS.include?(data.extension) or
          TARGET_MIME_TYPES.include?(data.mime_type)
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
          output = Tempfile.new("chupa-text-decomposer-libreoffice-output")
          error_output = Tempfile.new("chupa-text-decomposer-libreoffice-error")
          succeeded = @command.run("--headless",
                                   "--nologo",
                                   "--convert-to", "pdf",
                                   "--outdir", temporary_directory,
                                   data.path.to_s,
                                   {
                                     :spawn_options => {
                                       :out => output.path,
                                       :err => error_output.path,
                                     },
                                   })
          unless succeeded
            error do
              tag = "#{log_tag}[convert][exited][abnormally]"
              [
                tag,
                "output: <#{output.read}>",
                "error: <#{error_output.read}>",
              ].join("\n")
            end
            return nil
          end
          pdf_path, = Dir.glob("#{temporary_directory}/*.pdf")
          if pdf_path.nil?
            error do
              tag = "#{log_tag}[convert][failed]"
              message = [
                "#{tag}: LibreOffice may be running",
                "output: <#{output.read}>",
                "error: <#{error_output.read}>",
              ].join("\n")
            end
            return nil
          end
          normalized_pdf_uri = data.uri.to_s.gsub(/\.[^.]+\z/, ".pdf")
          File.open(pdf_path, "rb") do |pdf|
            ChupaText::VirtualFileData.new(normalized_pdf_uri,
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
