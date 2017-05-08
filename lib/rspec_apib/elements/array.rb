module RSpecApib
  module Element
    class Array < ::Array
      def self.from_hash(hash, index:, parent:)
        new(hash["content"])
      end
    end
  end
end
