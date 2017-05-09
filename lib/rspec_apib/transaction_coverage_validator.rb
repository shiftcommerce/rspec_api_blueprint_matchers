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
      reporter.report_uncovered(errors: errors)
      reporter.report_undocumented(errors: errors)
      report_summary(errors: errors, error_messages: error_messages)
    end

    private

    def report_summary(errors:, error_messages:)
      if !errors.empty?
        error_messages.concat errors
        error_messages << "Coverage Summary: #{uncovered.length} uncovered and #{undocumented.length} undocumented transactions"
        false
      else
        true
      end
    end

    attr_accessor :parser

    def matched_transaction(request:, response:)
      parser.http_transactions.find { |t| t.matches?(request, response, options: {validate_request_schema: :never, validate_response_schema: :never}) }
    end
  end
end
