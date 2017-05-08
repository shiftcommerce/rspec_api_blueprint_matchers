require "addressable"
module RSpecApib
  module Element
    class HrefVariables < Base
      def [](key)
        member = content.find {|h| h.is_a?(Member) && h.content.key?(key) }
        return nil if member.nil?
        member.content[key]
      end

    end
  end
end
