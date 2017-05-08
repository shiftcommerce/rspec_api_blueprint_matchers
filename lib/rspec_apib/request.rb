# frozen_string_literal: true
require "forwardable"
module RSpecApib
  class Request
    extend Forwardable
    def initialize(request)
      self.raw_request = request
    end

    def request_method
      raw_request.method
    end

    delegate url: :raw_request

    def validate_body_with_json_schema?
      request_method != :get && json?
    end

    # The request body
    # @return [String] The request body - always as a string
    delegate body: :raw_request

    def content_type
      headers["Content-Type"]
    end

    def headers
      raw_request.request_headers
    end

    private

    attr_accessor :raw_request

    def json?
      content_type =~ /json/
    end

  end
end
