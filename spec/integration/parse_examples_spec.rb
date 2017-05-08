# frozen_string_literal: true
require "spec_helper"
module RSpecApib
  RSpec.describe Parser do
    let(:examples_path) { File.expand_path("../fixtures/examples", File.dirname(__FILE__)) }
    let(:parser) { Parser.new }
    context "#parse_file" do
      context "example 1 - simplest api" do
        let(:file) { File.join(examples_path, "01. Simplest API.md") }
        it "Should parse apiblueprint example without error" do
          results = parser.parse_file(file)
          expect(results).to be_a(Element::ParseResult)
        end

        it "should have 1 resource" do
          parser.parse_file(file)
          resources = parser.resources
          expect(resources).to match_array(instance_of(Element::Resource))
        end

        it "should have 1 transaction" do
          parser.parse_file(file)
          transactions = parser.http_transactions
          expect(transactions).to match_array(instance_of(Element::HttpTransaction))
        end

        it "should have a request inside the transaction" do
          parser.parse_file(file)
          transactions = parser.http_transactions
          expect(transactions.first.request).to be_a(Element::HttpRequest)
        end

        it "should have the correct path in the request inside the transaction" do
          parser.parse_file(file)
          transactions = parser.http_transactions
          expect(transactions.first.request.path).to eql "/message"
        end

        it "should have a response inside the transaction" do
          parser.parse_file(file)
          transactions = parser.http_transactions
          expect(transactions.first.response).to be_a(Element::HttpResponse)
        end

      end

      context "example 2 - resources and actions" do
        let(:file) { File.join(examples_path, "02. Resource and Actions.md") }
        it "Should parse apiblueprint example without error" do
          results = parser.parse_file(file)
          expect(results).to be_a(Element::ParseResult)
        end
      end

      context "example 3 - named resources and actions" do
        let(:file) { File.join(examples_path, "03. Named Resource and Actions.md") }
        it "Should parse apiblueprint example without error" do
          results = parser.parse_file(file)
          expect(results).to be_a(Element::ParseResult)
        end
      end

      context "example 4 - grouing resources" do
        let(:file) { File.join(examples_path, "04. Grouping Resources.md") }
        it "Should parse apiblueprint example without error" do
          results = parser.parse_file(file)
          expect(results).to be_a(Element::ParseResult)
        end
      end

      context "example 5 - responses" do
        let(:file) { File.join(examples_path, "05. Responses.md") }
        it "Should parse apiblueprint example without error" do
          results = parser.parse_file(file)
          expect(results).to be_a(Element::ParseResult)
        end
      end

      context "example 6 - requests" do
        let(:file) { File.join(examples_path, "06. Requests.md") }
        it "Should parse apiblueprint example without error" do
          results = parser.parse_file(file)
          expect(results).to be_a(Element::ParseResult)
        end
      end

      context "example 7 - parameters" do
        let(:file) { File.join(examples_path, "07. Parameters.md") }
        it "Should parse apiblueprint example without error" do
          results = parser.parse_file(file)
          expect(results).to be_a(Element::ParseResult)
        end
      end

      context "example 8 - attributes" do
        let(:file) { File.join(examples_path, "08. Attributes.md") }
        it "Should parse apiblueprint example without error" do
          results = parser.parse_file(file)
          expect(results).to be_a(Element::ParseResult)
        end
      end

      context "example 9 - advanced attributes" do
        let(:file) { File.join(examples_path, "09. Advanced Attributes.md") }
        it "Should parse apiblueprint example without error" do
          results = parser.parse_file(file)
          expect(results).to be_a(Element::ParseResult)
        end
      end

      context "example 10 - data structures" do
        let(:file) { File.join(examples_path, "10. Data Structures.md") }
        it "Should parse apiblueprint example without error" do
          results = parser.parse_file(file)
          expect(results).to be_a(Element::ParseResult)
        end
      end

      context "example 11 - resource model" do
        let(:file) { File.join(examples_path, "11. Resource Model.md") }
        it "Should parse apiblueprint example without error" do
          results = parser.parse_file(file)
          expect(results).to be_a(Element::ParseResult)
        end
      end

      context "example 12 - advanced action" do
        let(:file) { File.join(examples_path, "12. Advanced Action.md") }
        it "Should parse apiblueprint example without error" do
          results = parser.parse_file(file)
          expect(results).to be_a(Element::ParseResult)
        end
      end

      context "example 13 - named endpoints" do
        let(:file) { File.join(examples_path, "13. Named Endpoints.md") }
        it "Should parse apiblueprint example without error" do
          results = parser.parse_file(file)
          expect(results).to be_a(Element::ParseResult)
        end
      end

      context "example 14 - json schema" do
        let(:file) { File.join(examples_path, "14. JSON Schema.md") }
        it "Should parse apiblueprint example without error" do
          results = parser.parse_file(file)
          expect(results).to be_a(Element::ParseResult)
        end
      end

      context "example 15 - advanced json schema" do
        let(:file) { File.join(examples_path, "15. Advanced JSON Schema.md") }
        it "Should parse apiblueprint example without error" do
          results = parser.parse_file(file)
          expect(results).to be_a(Element::ParseResult)
        end
      end

      context "Gist Fox API + Auth" do
        let(:file) { File.join(examples_path, "Gist Fox API + Auth.md") }
        it "Should parse apiblueprint example without error" do
          results = parser.parse_file(file)
          expect(results).to be_a(Element::ParseResult)
        end
      end

      context "Gist Fox API" do
        let(:file) { File.join(examples_path, "Gist Fox API.md") }
        it "Should parse apiblueprint example without error" do
          results = parser.parse_file(file)
          expect(results).to be_a(Element::ParseResult)
        end
      end

      context "Polls API" do
        let(:file) { File.join(examples_path, "Polls API.md") }
        it "Should parse apiblueprint example without error" do
          results = parser.parse_file(file)
          expect(results).to be_a(Element::ParseResult)
        end
      end

      context "Polls Hypermedia API" do
        let(:file) { File.join(examples_path, "Polls Hypermedia API.md") }
        it "Should parse apiblueprint example without error" do
          results = parser.parse_file(file)
          expect(results).to be_a(Element::ParseResult)
        end
      end

      context "Real World API" do
        let(:file) { File.join(examples_path, "Real World API.md") }
        it "Should parse apiblueprint example without error" do
          results = parser.parse_file(file)
          expect(results).to be_a(Element::ParseResult)
        end
      end
    end
  end
end
