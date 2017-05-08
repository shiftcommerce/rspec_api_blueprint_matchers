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
        matching_transactions = documented_transaction_tracker.keys.each do |dtx|
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

    private

    attr_accessor :transactions, :parser
  end
end
