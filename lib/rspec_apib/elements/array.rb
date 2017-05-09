# frozen_string_literal: true
module RSpecApib
  module Element
    # Represents an array in api-elements (http://api-elements.readthedocs.io/en/latest/)
    class Array < ::Array
      # rubocop:disable Lint/UnusedMethodArgument
      def self.from_hash(hash, index:, parent:)
        new(hash["content"])
      end
    end
  end
end
