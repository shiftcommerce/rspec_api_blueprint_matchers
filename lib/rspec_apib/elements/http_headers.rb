module RSpecApib
  module Element
    class HttpHeaders < Base
      def [](key)
        member = content.find {|h| h.is_a?(Member) && h.content.key?(key) }
        return nil if member.nil?
        member.content[key]
      end

      def each_pair
        content.select {|h| h.is_a?(Member)}.each do |header|
          yield header.key, header.value
        end
      end

      def keep_if
        results = dup
        results.content = []
        content.select {|h| h.is_a?(Member)}.each do |header|
          results.content << header if yield header.key, header.value
        end
        results
      end

    end
  end
end
