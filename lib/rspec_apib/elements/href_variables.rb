# frozen_string_literal: true
require "addressable"
module RSpecApib
  module Element
    # Represents a collection of href variables in api-elements (http://api-elements.readthedocs.io/en/latest/)
    class HrefVariables < Base
      def [](key)
        member = content.find { |h| h.is_a?(Member) && h.content.key?(key) }
        return nil if member.nil?
        member.content[key]
      end
    end
  end
end
