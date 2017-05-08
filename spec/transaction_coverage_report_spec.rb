# frozen_string_literal: true
require "spec_helper"
module RSpecApib
  RSpec.describe TransactionCoverageReport do
    let(:parser) { Parser.new } # We will use this everywhere
    context "#uncovered_transactions" do
      it "should list transactions that are documented but not in list" do
        mock_transactions = [
          double(
            "Transaction1",
            request: instance_double("Request", request_method: :get, url: URI.parse("http://polls.apiblueprint.org/")),
            response: instance_double("Response", status: "200", body: "{\"questions_url\":\"/questions\"}", content_type: "application/json", headers: {"Content-Type" => "application/json"})
          )
        ]
        parser.parse_file(File.expand_path("./fixtures/examples/Polls API.md", File.dirname(__FILE__)))
        report = TransactionCoverageReport.new(transactions: mock_transactions, parser: parser)
        expect(report.uncovered_transactions.length).to eql 4
      end
    end

    context "#undocumented_transactions" do
      it "should list transactions for un documented requests" do
        mock_transactions = [
          double(
            "Transaction1",
            request: instance_double("Request", request_method: :get, url: URI.parse("http://polls.apiblueprint.org/")),
            response: instance_double("Response", status: "200", body: "{\"questions_url\":\"/questions\"}", content_type: "application/json", headers: {"Content-Type" => "application/json"})
          ),
          double(
            "Transaction1",
            request: instance_double("Request", request_method: :get, url: URI.parse("http://polls.apiblueprint.org/new_resources")),
            response: instance_double("Response", status: "200", body: "[{\"name\":\"/irrelevant\"}]", content_type: "application/json", headers: {"Content-Type" => "application/json"})
          )
        ]
        parser.parse_file(File.expand_path("./fixtures/examples/Polls API.md", File.dirname(__FILE__)))
        report = TransactionCoverageReport.new(transactions: mock_transactions, parser: parser)
        expect(report.undocumented_transactions.length).to eql 1
        expect(report.undocumented_transactions[0]).to be mock_transactions[1]
      end
    end

  end
end
