# frozen_string_literal: true
module RSpecApib
  module Element
    # Represents a collection of http headers in api-elements (http://api-elements.readthedocs.io/en/latest/)
    class HttpHeaders < Base
      def [](key)
        member = content.find { |http_header| http_header.is_a?(Member) && http_header.content.key?(key) }
        return nil if member.nil?
        member.content[key]
      end

      def each_pair
        content.select { |http_header| http_header.is_a?(Member) }.each do |header|
          yield header.key, header.value
        end
      end

      def keep_if
        results = dup
        results.content = []
        content.select { |http_header| http_header.is_a?(Member) }.each do |header|
          results.content << header if yield header.key, header.value
        end
        results
      end
    end
  end
end
