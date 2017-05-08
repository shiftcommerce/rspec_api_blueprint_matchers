# frozen_string_literal: true
require "spec_helper"
module RSpecApib
  describe Parser do
    let(:fixtures_path) { File.expand_path("./fixtures", File.dirname(__FILE__)) }
    let(:parser) { Parser.new }
    it "should parse the given file" do
      file = File.join(fixtures_path, "basic.apib")
      results = parser.parse_file(file)
      expect(results).to be_a(Element::ParseResult)
    end
  end
end
