# frozen_string_literal: true
require "rspec/matchers"
require "rspec_apib/transaction_validator"
require "rspec_apib/transaction_coverage_validator"
RSpec::Matchers.define :match_api_docs_for do |path:, request_method:, content_type:, parser: RSpecApib.config.default_parser|
  error_messages = []
  match do |actual|
    if actual.nil?
      error_messages << "Expected the transaction to match api docs for #{method}:#{path} but it was nil"
      false
    elsif !parser.is_a?(RSpecApib::Parser)
      error_messages << "Expected the transaction to match api docs for #{method}:#{path} but the provided parser was invalid"
      false
    else
      ::RSpecApib::TransactionValidator.new(path: path, request_method: request_method, content_type: content_type, parser: parser).validate(request: ::RSpecApib.normalize_request(actual.request), response: ::RSpecApib.normalize_response(actual.response), error_messages: error_messages)
    end

  end

  failure_message do |_actual|
    error_messages.join("\n")
  end
end

RSpec::Matchers.define :have_covered_all_api_documentation do |parser: RSpecApib.config.default_parser|
  error_messages = []
  Transaction = Struct.new(:request, :response)
  match do |actual|
    error_messages << "No API calls were made" if actual.empty?

    normalized_transactions = actual.map do |tx|
      Transaction.new(RSpecApib.normalize_request(tx.request), RSpecApib.normalize_response(tx.response))
    end
    ::RSpecApib::TransactionCoverageValidator.new(parser: parser).validate(transactions: normalized_transactions, error_messages: error_messages)

  end

  failure_message do |_actual|
    error_messages.join("\n")
  end
end
