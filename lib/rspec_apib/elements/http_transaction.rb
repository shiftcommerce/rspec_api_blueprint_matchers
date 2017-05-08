# frozen_string_literal: true
module RSpecApib
  module Element
    # Represents a http transaction in api-elements (http://api-elements.readthedocs.io/en/latest/)
    class HttpTransaction < Base
      def matches?(request_in, response_in, options: {})
        request.matches?(request_in, options: options) && response.matches?(response_in, options: options)
      end

      def potential_match?(path:, request_method:, content_type:)
        potential_match_content_type?(content_type) &&
          (request_method == :any || request_method == request.request_method) &&
          (path == :any || request.path == path)
      end

      def validate_schema(request_in, response_in, validate_request_schema: :always, validate_response_schema: :always)
        request_errors = validate_request_schema(request_in, validate_request_schema)
        response_errors = validate_response_schema(response_in, validate_response_schema)
        { request_errors: request_errors, response_errors: response_errors }
      end

      def request
        @request ||= content.find {|r| r.is_a?(HttpRequest)}
      end

      def response
        @response ||= content.find {|r| r.is_a?(HttpResponse)}
      end

      private

      def potential_match_content_type?(content_type)
        content_type == :any || content_type == (response.content_type || request.content_type)
      end

      def validate_request_schema(request_in, validate_request_schema)
        return [] if validate_request_schema == :never
        request.validate_schema(request_in, allow_no_schema: (validate_request_schema == :when_defined))
      end

      def validate_response_schema(response_in, validate_response_schema)
        return [] if validate_response_schema == :never
        response.validate_schema(response_in, allow_no_schema: (validate_response_schema == :when_defined))
      end

      # Inherit href and hrefVariables from any ancestor
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
