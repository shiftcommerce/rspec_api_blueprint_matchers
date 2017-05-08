require "rspec_apib/elements/http_message_payload"
module RSpecApib
  module Element
    # Represents a http response in api-elements (http://api-elements.readthedocs.io/en/latest/)
    class HttpResponse < HttpMessagePayload
      # Indicates if the incoming request matches the method, path and path vars
      # @param [::RSpecApib::Request] The incoming request - normalized
      # @return [Boolean] true if matches else false
      def matches?(response, options: {})
        matches_status?(response) &&
        matches_content_type?(response)
      end

      def status
        attributes["statusCode"]
      end

      private

      def matches_status?(response)
        response.status == attributes["statusCode"]
      end

      def matches_content_type?(response)
        expected_content_type = content_type
        expected_content_type.nil? || (expected_content_type == response.content_type)
      end

      def self.attributes_schema
        {
          href: "TemplatedHref"
        }
      end
    end
  end
end
