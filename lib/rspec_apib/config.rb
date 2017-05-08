module RSpecApib
  class Config
    attr_accessor :default_blueprint_file
    def batch_configure
      yield self
    end

    # The default Parser
    # If a single blueprint file is used throughout specs then by not specifying
    # your own parser in your examples, this default will be used which has pre
    # parsed the default blueprint file
    # @return [::RSpecApib::Parser] The parser
    def default_parser
      @default_parser ||= Parser.new.tap { |p| p.parse_file(default_blueprint_file) }
    end
  end
end
