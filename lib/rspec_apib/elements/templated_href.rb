# frozen_string_literal: true
require "addressable"
module RSpecApib
  module Element
    # Represents a templated href in api-elements (http://api-elements.readthedocs.io/en/latest/)
    class TemplatedHref < Base
      # Note this is not really a hash but the interface named it
      # that early on as everything was a hash !!
      # rubocop:disable Lint/UnusedMethodArgument
      def self.from_hash(hash, index:, parent:)
        new("templatedHref", nil, nil, hash, parent)
      end

      def to_s
        content
      end

      def matches_path?(request)
        tpl = Addressable::Template.new(url)
        result = tpl.extract(request.url)
        !result.nil?
      end

      def url
        @url ||= File.join(self.class.host_from_parent(parent), content)
      end

      def path
        url_1 = Addressable::URI.parse(url)
        url_1.path, url_1.query, url_1.fragment = nil
        url_2 = Addressable::URI.parse(url)
        url_2.to_s.gsub(url_1.to_s, "")
      end

      def self.host_from_parent(node)
        return "" if node.nil?
        attrs = node.attributes
        return host_from_parent(node.parent) unless attrs && attrs["meta"]
        host_member = attrs["meta"].find do |member|
          member.is_a?(Member) && member.content.key?("HOST")
        end
        return host_from_parent(node.parent) unless host_member
        host_member.content["HOST"]
      end
    end
  end
end
