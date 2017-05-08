require "addressable"
module RSpecApib
  module Element
    class TemplatedHref < Base
      # Note this is not really a hash !!
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
        a1 = Addressable::URI.parse(url)
        a1.path, a1.query, a1.fragment = nil
        a2 = Addressable::URI.parse(url)
        a2.to_s.gsub(a1.to_s, "")
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
