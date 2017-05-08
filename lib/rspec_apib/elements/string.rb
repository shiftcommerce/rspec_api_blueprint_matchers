# frozen_string_literal: true
module RSpecApib
  module Element
    class String < ::String
      def self.from_hash(hash, index:, parent:)
        new(hash["content"] || "")
      end
    end
  end
end
