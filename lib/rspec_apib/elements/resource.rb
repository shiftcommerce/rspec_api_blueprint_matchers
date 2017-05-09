# frozen_string_literal: true
module RSpecApib
  module Element
    # Represents a resource in api-elements (http://api-elements.readthedocs.io/en/latest/)
    class Resource < Base
      def transitions
        content.select { |item| item.is_a?(Transition) }
      end

      def categories
        content.select { |item| item.is_a?(Category) }
      end

      def self.attributes_schema
        {
          href: "TemplatedHref"
        }
      end
    end
  end
end
