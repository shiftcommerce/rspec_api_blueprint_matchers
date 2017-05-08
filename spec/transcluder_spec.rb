# frozen_string_literal: true
require "spec_helper"
module RSpecApib
  RSpec.describe Transcluder do
    let(:fixtures_path) { File.expand_path("./fixtures", File.dirname(__FILE__)) }
    it "should include the contents of one file in another" do
      file_path = File.join(fixtures_path, "parent.apib")
      str = ""
      Transcluder.each_line(file_path) do |line|
        str = str + line
      end
      expect(str).to include("This is the root file")
      expect(str).to include("This Is The Child File")
      expect(str).to include("This is still the root file")
    end
  end
end
