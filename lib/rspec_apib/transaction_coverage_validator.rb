# frozen_string_literal: true
require "rspec_apib/transaction_coverage_report"
module RSpecApib
  class TransactionCoverageValidator
    def initialize(parser: RSpecApib.config.default_parser)
      self.parser = parser
    end

    def validate(transactions:, error_messages:)
      errors = []
      reporter = TransactionCoverageReport.new(transactions: transactions, parser: parser)
      uncovered = reporter.uncovered_transactions
      unless uncovered.empty?
        uncovered.each do |tx|
          errors << self.class.uncovered_tx_message(tx)
        end
      end
      undocumented = reporter.undocumented_transactions
      unless undocumented.empty?
        undocumented.each do |tx|
          errors << self.class.undocumented_tx_message(tx)
        end
      end
      if !errors.empty?
        error_messages.concat errors
        error_messages << "Coverage Summary: #{uncovered.length} uncovered and #{undocumented.length} undocumented transactions"
        false
      else
        true
      end
    end

    private

    attr_accessor :parser

    def matched_transaction(request:, response:)
      parser.http_transactions.find { |t| t.matches?(request, response, options: {validate_request_schema: :never, validate_response_schema: :never}) }
    end

    def self.uncovered_tx_message(tx)
      "#{tx.request.request_method.to_s.upcase} #{tx.request.url} with response (#{tx.response.content_type}) status #{tx.response.status}- Not covered"
    end

    def self.undocumented_tx_message(tx)
      "#{tx.request.request_method.upcase} #{tx.request.url} with response (#{tx.response.content_type}) status #{tx.response.status} - Not documented"
    end

  end
end
