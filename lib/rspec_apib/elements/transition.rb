# frozen_string_literal: true
module RSpecApib
  module Element
    # Represents a transition in api-elements (http://api-elements.readthedocs.io/en/latest/)
    class Transition < Base
      def http_transactions
        content.select { |item| item.is_a?(HttpTransaction) }
      end

      # Inherit href and hrefVariables from any ancestor (normally resource)
      def self.attrs_to_inherit
        [:href, :hrefVariables]
      end

      def self.attributes_schema
        {
          href: "TemplatedHref"
        }
      end
    end
  end
end
