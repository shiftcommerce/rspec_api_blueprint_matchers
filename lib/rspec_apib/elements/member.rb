module RSpecApib
  module Element
    # Represents a member in api-elements (http://api-elements.readthedocs.io/en/latest/)
    class Member < Base
      def self.from_hash(hash, index:, parent:)
        child = super
        content = child.content
        child.content = { content['key'] => content['value'] }
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
