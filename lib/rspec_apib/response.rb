require "json"
module RSpecApib
  class Response
    def initialize(response)
      self.raw_response = response
    end

    def status
      raw_response.status.to_s
    end

    # The response body
    # @return [String] The response body - always as a string
    def body
      JSON.generate raw_response.body
    end

    def validate_body_with_json_schema?
      is_json?
    end

    def content_type
      headers["Content-Type"]
    end

    def headers
      raw_response.response_headers
    end


    private

    attr_accessor :raw_response

    def is_json?
      content_type=~/json/
    end
  end
end
