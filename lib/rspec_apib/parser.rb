# frozen_string_literal: true
require "rspec_apib/transcluder"
require "rspec_apib/extractors"
require "rspec_apib/elements"
require "open3"
require "json"
module RSpecApib
  class Parser

    def initialize(transcluder: Transcluder, base_element: Element::Base)
      self.transcluder = transcluder
      self.base_element = base_element
    end

    def parse_file(file)
      self.parsed_file = call_parser(file)
      document, index = parse_document
      self.document = document
      self.index = index
      document
    end

    def resources
      index[Element::Resource]
    end

    def categories
      index[Element::Category]
    end

    def copies
      index[Element::Copy]
    end

    def transitions
      index[Element::Transition]
    end

    def http_transactions
      index[Element::HttpTransaction]
    end

    def http_requests
      index[Element::HttpRequest]
    end

    def http_responses
      index[Element::HttpResponse]
    end

    def asset
      index[Element::Asset]
    end

    private

    attr_accessor :transcluder, :parsed_file, :document, :base_element, :index

    def parse_document
      base_element.parse_root(parsed_file)
    end

    def bin_path
      "drafter"
    end

    def call_parser(file)
      op = nil
      Open3.popen3("#{bin_path} -f json") do |stdin, stdout, _stderr, wait_thr|
        transcluder.each_line(file) do |line|
          stdin.write line
        end
        stdin.close
        op = stdout.read
        exit_status = wait_thr.value
      end
      JSON.parse op
    end
  end
end
