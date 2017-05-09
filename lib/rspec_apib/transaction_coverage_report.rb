# frozen_string_literal: true
module RSpecApib
  class TransactionCoverageReport
    def initialize(transactions:, parser: RSpecApib.config.default_parser)
      self.transactions = transactions
      self.parser = parser
    end

    def uncovered_transactions
      documented_transaction_tracker = parser.http_transactions.each_with_object({}) do |t, acc|
        acc[t] = false
        acc
      end
      transactions.each do |requested_tx|
        documented_transaction_tracker.keys.each do |dtx|
          documented_transaction_tracker[dtx] = true if dtx.matches?(requested_tx.request, requested_tx.response)
        end
      end
      documented_transaction_tracker.reject {|_k, v| v}.keys
    end

    def undocumented_transactions
      results = []
      transactions.each do |requested_tx|
        match = parser.http_transactions.find do |doc_txn|
          doc_txn.matches?(requested_tx.request, requested_tx.response)
        end
        results << requested_tx if match.nil?
      end
      results
    end

    def report_uncovered(errors:)
      uncovered_transactions.each do |tx|
        errors << self.class.uncovered_tx_message(tx)
      end
    end

    def report_undocumented(errors:)
      undocumented.each do |tx|
        errors << self.class.undocumented_tx_message(tx)
      end
    end

    private

    attr_accessor :transactions, :parser

    def self.uncovered_tx_message(tx)
      "#{tx.request.request_method.to_s.upcase} #{tx.request.url} with response (#{tx.response.content_type}) status #{tx.response.status}- Not covered"
    end

    def self.undocumented_tx_message(tx)
      "#{tx.request.request_method.upcase} #{tx.request.url} with response (#{tx.response.content_type}) status #{tx.response.status} - Not documented"
    end

  end
end
