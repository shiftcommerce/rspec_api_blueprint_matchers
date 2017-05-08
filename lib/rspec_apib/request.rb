module RSpecApib
  class Request
    def initialize(request)
      self.raw_request = request
    end

    def request_method
      raw_request.method
    end

    def url
      raw_request.url
    end

    def validate_body_with_json_schema?
      request_method != :get && is_json?
    end

    # The request body
    # @return [String] The request body - always as a string
    def body
      raw_request.body
    end

    def content_type
      headers["Content-Type"]
    end

    def headers
      raw_request.request_headers
    end


    private

    attr_accessor :raw_request

    def is_json?
      content_type =~ /json/
    end


  end
end
