# frozen_string_literal: true
module RSpecApib
  class TransactionValidator
    # validate_request_schema can be :always, :never, :when_defined
    def initialize(path:, request_method:, content_type:, validate_request_schema: :always, validate_response_schema: :always, parser: RSpecApib.config.default_parser)
      self.path = path
      self.request_method = request_method
      self.content_type = content_type
      self.parser = parser
      self.validate_request_schema = validate_request_schema
      self.validate_response_schema = validate_response_schema
    end

    def validate(request:, response:, error_messages:, options: {})
      results = matched_transactions(request, response, options)
      if results.empty?
        error_messages << "No candidates for #{request.inspect} with response #{response.inspect}"
        return false
      end

      return true unless results.flatten.find {|r| !r[:request_errors].empty? || !r[:response_errors].empty?}
      report_error_messages(results, error_messages)
      false
    end

    private

    def report_error_messages(results, error_messages)
      results.each do |result|
        error_messages << "The request validation failed - reasons #{result[:request_errors].join("\n")}" unless result[:request_errors].empty?
        error_messages << "The response validation failed - reasons #{result[:response_errors].join("\n")}" unless result[:response_errors].empty?
      end
    end

    def matched_transactions(request, response, options)
      candidates = transaction_candidates(request: request, response: response, options: options)
      candidates.map do |candidate|
        candidate.validate_schema(request, response, validate_request_schema: validate_request_schema, validate_response_schema: validate_response_schema)
      end
    end

    def transaction_candidates(request:, response:, options: {})
      transactions = parser.http_transactions.select do |t|
        t.potential_match?(path: path, request_method: request_method, content_type: content_type)
      end
      transactions.select { |t| t.matches?(request, response, options: options) }
    end

    attr_accessor :path, :request_method, :content_type, :parser, :validate_request_schema, :validate_response_schema

  end
end
