require "json-schema"
require "rspec_apib/elements/http_message_payload"
module RSpecApib
  module Element
    class HttpRequest < HttpMessagePayload

      # Indicates if the incoming request matches the method, path and path vars
      # @param [::RSpecApib::Request] The incoming request - normalized
      # @return [Boolean] true if matches else false
      def matches?(request, options: {})
        matches_method?(request) &&
        matches_path?(request) &&
        matches_headers?(request, options)
      end

      # Inherit href and hrefVariables from any ancestor
      def self.attrs_to_inherit
        [:href, :hrefVariables, :method]
      end

      def request_method
        attributes && attributes["method"] && attributes["method"].downcase.to_sym
      end

      def path
        attributes && attributes["href"] && attributes["href"].path
      end

      def url
        attributes && attributes["href"].to_s
      end

      private

      def matches_headers?(request_or_response, options)
        headers = attributes && attributes["headers"] && attributes["headers"].keep_if {|k, v| k == "Content-Type" || k == "Accept"}
        return true if headers.nil?
        headers.each_pair do |header_key, header_value|
          return false unless request_or_response.headers.key?(header_key) &&
                              request_or_response.headers[header_key] == header_value
        end
      end

      def matches_method?(request)
        attributes && attributes["method"] && attributes["method"].downcase.to_sym == request.request_method
      end

      def matches_path?(request)
        attributes && attributes["href"] && attributes["href"].matches_path?(request)
      end

      def self.attributes_schema
        {
          href: "TemplatedHref"
        }
      end
    end
  end
end
