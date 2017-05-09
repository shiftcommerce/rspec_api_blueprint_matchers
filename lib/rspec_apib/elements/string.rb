# frozen_string_literal: true
module RSpecApib
  module Element
    # Represents a string in api-elements (http://api-elements.readthedocs.io/en/latest/)
    class String < ::String
      # rubocop:disable Lint/UnusedMethodArgument
      def self.from_hash(hash, index:, parent:)
        new(hash["content"] || "")
      end
    end
  end
end
