# frozen_string_literal: true
require "json-schema"
require "rspec_apib/elements/http_message_payload"
module RSpecApib
  module Element
    # Represents a http message payload in api-elements (http://api-elements.readthedocs.io/en/latest/)
    class HttpMessagePayload < Base
      # The content type if defined else nil
      # @return [String | NilClass] The content type header or nil
      def content_type
        attributes["headers"] && attributes["headers"]["Content-Type"]
      end

      def validate_schema(request_or_response, allow_no_schema: false)
        return [] unless request_or_response.validate_body_with_json_schema?
        schema = body_schema_asset
        return [] if schema.nil? && allow_no_schema
        if schema.nil?
          failure_reason = {
            success: false,
            reason: "Missing a body schema",
            details: []
          }
          return [failure_reason]
        end
        schema = JSON.parse schema.content
        errors = JSON::Validator.fully_validate(schema, request_or_response.body)
        return [] if errors.length.zero?

        failure_reason = {
          success: false,
          reason: "Schema validation failure",
          details: errors
        }
        [failure_reason]
      end

      private

      def body_schema_asset
        content.find { |node| node.is_a?(Asset) && node.meta && node.meta["classes"] && node.meta["classes"].include?("messageBodySchema")}
      end
    end
  end
end
