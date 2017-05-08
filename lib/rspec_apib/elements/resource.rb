# frozen_string_literal: true
module RSpecApib
  module Element
    # (byebug) parent.parent["attributes"]
    # {"meta"=>[#<struct RSpecApib::Element::Member element="member", meta={"classes"=>["user"]}, attributes={}, content={"FORMAT"=>"1A"}, parent=#<struct RSpecApib::Element::ParseResult element="parseResult", meta=nil, attributes=nil, content=nil, parent=nil>>, #<struct RSpecApib::Element::Member element="member", meta={"classes"=>["user"]}, attributes={}, content={"HOST"=>"http://api.shiftcommerce.com/inventory/v1"}, parent=#<struct RSpecApib::Element::ParseResult element="parseResult", meta=nil, attributes=nil, content=nil, parent=nil>>]}

    class Resource < Base
      def transitions
        content.select { |item| item.is_a?(Transition) }
      end

      def categories
        content.select { |item| item.is_a?(Category) }
      end

      private

      def self.attributes_schema
        {
          href: "TemplatedHref"
        }
      end
    end
  end
end
