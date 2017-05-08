module RSpecApib
  module Element
    class Member < Base

      def self.from_hash(hash, index:, parent:)
        child = super
        content = child.content
        child.content = {content["key"] => content["value"]}
        child
      end

      def key
        content.keys.first
      end

      def value
        content.values.first
      end
    end
  end
end
