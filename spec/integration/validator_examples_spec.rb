require "spec_helper"
module RSpecApib
  RSpec.describe TransactionValidator do
    let(:examples_path) { File.expand_path("../fixtures/examples", File.dirname(__FILE__)) }
    let(:parser) { Parser.new.tap { |p| p.parse_file(file) } }
    let(:error_messages) { [] } # Used in every example as as collector for errors
    context "#validate" do
      context "example 1 - simplest api" do
        let(:file) { File.join(examples_path, "01. Simplest API.md") }
        it "should validate when a correct request is made" do
          request = Request.new(double("Request", method: :get, url: URI.parse("/message")))
          response = Response.new(double("Response", status: 200, body: "Hello World!", response_headers: {"Content-Type" => "text/plain"}))
          validator = TransactionValidator.new(path: "/message", request_method: :get, content_type: "text/plain", parser: parser)

          expect(validator.validate(request: request, response: response, error_messages: error_messages)).to be true
          expect(error_messages).to be_empty
        end

        it "should fail validation with response not found when a response with invalid content type is provided" do
          request = Request.new(double("Request", method: :get, url: URI.parse("/message")))
          response = Response.new(double("Response", status: 200, body: "Hello World!", response_headers: {"Content-Type" => "application/json"}))
          validator = TransactionValidator.new(path: "/message", request_method: :get, content_type: "text/plain", parser: parser)

          expect(validator.validate(request: request, response: response, error_messages: error_messages)).to be false
          expect(error_messages).to include(a_string_matching(/No candidates for/))
        end

        it "should fail validation if the content type to match against is different" do
          request = Request.new(double("Request", method: :get, url: URI.parse("/message")))
          response = Response.new(double("Response", status: 200, body: "Hello World!", response_headers: {"Content-Type" => "text/plain"}))
          validator = TransactionValidator.new(path: "/message", request_method: :get, content_type: "application/json", parser: parser)

          expect(validator.validate(request: request, response: response, error_messages: error_messages)).to be false
          expect(error_messages).to include(a_string_matching(/No candidates for/))
        end

        it "should fail validation if the content type is not defined" do
          request = Request.new(double("Request", method: :get, url: URI.parse("/message")))
          response = Response.new(double("Response", status: 200, body: "Hello World!", response_headers: {"Content-Type" => "application/json"}))
          validator = TransactionValidator.new(path: "/message", request_method: :get, content_type: "application/json", parser: parser)

          expect(validator.validate(request: request, response: response, error_messages: error_messages)).to be false
          expect(error_messages).to include(a_string_matching(/No candidates for/))
        end

        it "should fail validation if the request method to match against is different" do
          request = Request.new(double("Request", method: :get, url: URI.parse("/message")))
          response = Response.new(double("Response", status: 200, body: "Hello World!", response_headers: {"Content-Type" => "text/plain"}))
          validator = TransactionValidator.new(path: "/message", request_method: :head, content_type: "text/plain", parser: parser)

          expect(validator.validate(request: request, response: response, error_messages: error_messages)).to be false
          expect(error_messages).to include(a_string_matching(/No candidates for/))
        end

        it "should fail validation if the request's request_method is different" do
          request = Request.new(double("Request", method: :head, url: URI.parse("/message")))
          response = Response.new(double("Response", status: 200, body: "Hello World!", response_headers: {"Content-Type" => "text/plain"}))
          validator = TransactionValidator.new(path: "/message", request_method: :get, content_type: "text/plain", parser: parser)

          expect(validator.validate(request: request, response: response, error_messages: error_messages)).to be false
          expect(error_messages).to include(a_string_matching(/No candidates for/))
        end

        it "should fail validation if the request's request_method not defined" do
          request = Request.new(double("Request", method: :head, url: URI.parse("/message")))
          response = Response.new(double("Response", status: 200, body: "Hello World!", response_headers: {"Content-Type" => "text/plain"}))
          validator = TransactionValidator.new(path: "/message", request_method: :head, content_type: "text/plain", parser: parser)

          expect(validator.validate(request: request, response: response, error_messages: error_messages)).to be false
          expect(error_messages).to include(a_string_matching(/No candidates for/))
        end

        it "should fail validation if the path to match against is different" do
          request = Request.new(double("Request", method: :get, url: URI.parse("/message")))
          response = Response.new(double("Response", status: 200, body: "Hello World!", response_headers: {"Content-Type" => "text/plain"}))
          validator = TransactionValidator.new(path: "/wrong_message", request_method: :get, content_type: "text/plain", parser: parser)

          expect(validator.validate(request: request, response: response, error_messages: error_messages)).to be false
          expect(error_messages).to include(a_string_matching(/No candidates for/))
        end

        it "should fail validation if the request's path is different" do
          request = Request.new(double("Request", method: :get, url: URI.parse("/wrong_message")))
          response = Response.new(double("Response", status: 200, body: "Hello World!", response_headers: {"Content-Type" => "text/plain"}))
          validator = TransactionValidator.new(path: "/message", request_method: :get, content_type: "text/plain", parser: parser)

          expect(validator.validate(request: request, response: response, error_messages: error_messages)).to be false
          expect(error_messages).to include(a_string_matching(/No candidates for/))
        end

        it "should fail validation if the request's path is not defined" do
          request = Request.new(double("Request", method: :get, url: URI.parse("/wrong_message")))
          response = Response.new(double("Response", status: 200, body: "Hello World!", response_headers: {"Content-Type" => "text/plain"}))
          validator = TransactionValidator.new(path: "/wrong_message", request_method: :head, content_type: "text/plain", parser: parser)

          expect(validator.validate(request: request, response: response, error_messages: error_messages)).to be false
          expect(error_messages).to include(a_string_matching(/No candidates for/))
        end

      end

      context "example 2 - resources and actions" do
        let(:file) { File.join(examples_path, "02. Resource and Actions.md") }

        it "should validate when a correct request is made to GET /message" do
          request = Request.new(double("Request", method: :get, url: URI.parse("/message")))
          response = Response.new(double("Response", status: 200, body: "Hello World!", response_headers: {"Content-Type" => "text/plain"}))
          validator = TransactionValidator.new(path: "/message", request_method: :get, content_type: "text/plain", parser: parser)

          expect(validator.validate(request: request, response: response, error_messages: error_messages)).to be true
          expect(error_messages).to be_empty
        end

        it "should validate when a correct request is made to PUT /message" do
          request = Request.new(double("Request", method: :put, url: URI.parse("/message"), request_headers: {"Content-Type" => "text/plain"}, body: "All your base are belong to us"))
          response = Response.new(double("Response", status: 204, body: "Hello World!", response_headers: {"Content-Type" => "text/plain"}))
          validator = TransactionValidator.new(path: "/message", request_method: :put, content_type: "text/plain", parser: parser)

          expect(validator.validate(request: request, response: response, error_messages: error_messages)).to be true
          expect(error_messages).to be_empty
        end

        it "should fail validation when an incorrect request is made to POST /message" do
          request = Request.new(double("Request", method: :post, url: URI.parse("/message"), request_headers: {"Content-Type" => "text/plain"}, body: "All your base are belong to us"))
          response = Response.new(double("Response", status: 204, body: "Hello World!", response_headers: {"Content-Type" => "text/plain"}))
          validator = TransactionValidator.new(path: "/message", request_method: :post, content_type: "text/plain", parser: parser)

          expect(validator.validate(request: request, response: response, error_messages: error_messages)).to be false
          expect(error_messages).to include(a_string_matching(/No candidates for/))
        end
      end

      context "example 3 - named resources and actions" do
        let(:file) { File.join(examples_path, "03. Named Resource and Actions.md") }
        it "should validate when a correct request is made to GET /message" do
          request = Request.new(double("Request", method: :get, url: URI.parse("/message")))
          response = Response.new(double("Response", status: 200, body: "Hello World!", response_headers: {"Content-Type" => "text/plain"}))
          validator = TransactionValidator.new(path: "/message", request_method: :get, content_type: "text/plain", parser: parser)

          expect(validator.validate(request: request, response: response, error_messages: error_messages)).to be true
          expect(error_messages).to be_empty
        end

        it "should validate when a correct request is made to PUT /message" do
          request = Request.new(double("Request", method: :put, url: URI.parse("/message"), request_headers: {"Content-Type" => "text/plain"}, body: "All your base are belong to us"))
          response = Response.new(double("Response", status: 204, body: "Hello World!", response_headers: {"Content-Type" => "text/plain"}))
          validator = TransactionValidator.new(path: "/message", request_method: :put, content_type: "text/plain", parser: parser)

          expect(validator.validate(request: request, response: response, error_messages: error_messages)).to be true
          expect(error_messages).to be_empty
        end

        it "should fail validation when an incorrect request is made to POST /message" do
          request = Request.new(double("Request", method: :post, url: URI.parse("/message"), request_headers: {"Content-Type" => "text/plain"}, body: "All your base are belong to us"))
          response = Response.new(double("Response", status: 204, body: "Hello World!", response_headers: {"Content-Type" => "text/plain"}))
          validator = TransactionValidator.new(path: "/message", request_method: :post, content_type: "text/plain", parser: parser)

          expect(validator.validate(request: request, response: response, error_messages: error_messages)).to be false
          expect(error_messages).to include(a_string_matching(/No candidates for/))
        end
      end

      context "example 4 - grouing resources" do
        let(:file) { File.join(examples_path, "04. Grouping Resources.md") }
        it "should validate when a correct request is made to GET /message" do
          request = Request.new(double("Request", method: :get, url: URI.parse("/message")))
          response = Response.new(double("Response", status: 200, body: "Hello World!", response_headers: {"Content-Type" => "text/plain"}))
          validator = TransactionValidator.new(path: "/message", request_method: :get, content_type: "text/plain", parser: parser)

          expect(validator.validate(request: request, response: response, error_messages: error_messages)).to be true
          expect(error_messages).to be_empty
        end

        it "should validate when a correct request is made to PUT /message" do
          request = Request.new(double("Request", method: :put, url: URI.parse("/message"), request_headers: {"Content-Type" => "text/plain"}, body: "All your base are belong to us"))
          response = Response.new(double("Response", status: 204, body: "Hello World!", response_headers: {"Content-Type" => "text/plain"}))
          validator = TransactionValidator.new(path: "/message", request_method: :put, content_type: "text/plain", parser: parser)

          expect(validator.validate(request: request, response: response, error_messages: error_messages)).to be true
          expect(error_messages).to be_empty
        end

        it "should fail validation when an incorrect request is made to POST /message" do
          request = Request.new(double("Request", method: :post, url: URI.parse("/message"), request_headers: {"Content-Type" => "text/plain"}, body: "All your base are belong to us"))
          response = Response.new(double("Response", status: 204, body: "Hello World!", response_headers: {"Content-Type" => "text/plain"}))
          validator = TransactionValidator.new(path: "/message", request_method: :post, content_type: "text/plain", parser: parser)

          expect(validator.validate(request: request, response: response, error_messages: error_messages)).to be false
          expect(error_messages).to include(a_string_matching(/No candidates for/))
        end
      end

      context "example 5 - responses" do
        let(:file) { File.join(examples_path, "05. Responses.md") }
        it "should validate when a correct request is made to GET /message" do
          request = Request.new(double("Request", method: :get, url: URI.parse("/message")))
          response = Response.new(double("Response", status: 200, body: "Hello World!", response_headers: {"Content-Type" => "text/plain", "X-My-Message-Header" => "42"}))
          validator = TransactionValidator.new(path: "/message", request_method: :get, content_type: "text/plain", parser: parser)

          expect(validator.validate(request: request, response: response, error_messages: error_messages)).to be true
          expect(error_messages).to be_empty
        end

        it "should validate when a correct request is made to PUT /message" do
          request = Request.new(double("Request", method: :put, url: URI.parse("/message"), request_headers: {"Content-Type" => "text/plain"}, body: "All your base are belong to us"))
          response = Response.new(double("Response", status: 204, body: "Hello World!", response_headers: {"Content-Type" => "text/plain", "X-My-Message-Header" => "42"}))
          validator = TransactionValidator.new(path: "/message", request_method: :put, content_type: "text/plain", parser: parser)

          expect(validator.validate(request: request, response: response, error_messages: error_messages)).to be true
          expect(error_messages).to be_empty
        end

        it "should fail validation when an incorrect request is made to POST /message" do
          request = Request.new(double("Request", method: :post, url: URI.parse("/message"), request_headers: {"Content-Type" => "text/plain"}, body: "All your base are belong to us"))
          response = Response.new(double("Response", status: 204, body: "Hello World!", response_headers: {"Content-Type" => "text/plain", "X-My-Message-Header" => "42"}))
          validator = TransactionValidator.new(path: "/message", request_method: :post, content_type: "text/plain", parser: parser)

          expect(validator.validate(request: request, response: response, error_messages: error_messages)).to be false
          expect(error_messages).to include(a_string_matching(/No candidates for/))
        end
      end

      context "example 6 - requests" do
        let(:file) { File.join(examples_path, "06. Requests.md") }
        it "should validate when a correct request is made to GET /message (text/plain)" do
          request = Request.new(double("Request", method: :get, url: URI.parse("/message"), request_headers: {"Accept" => "text/plain"}))
          response = Response.new(double("Response", status: 200, body: "Hello World!", response_headers: {"Content-Type" => "text/plain", "X-My-Message-Header" => "42"}))
          validator = TransactionValidator.new(path: "/message", request_method: :get, content_type: "text/plain", parser: parser)

          aggregate_failures do
            expect(validator.validate(request: request, response: response, error_messages: error_messages)).to be true
            expect(error_messages).to be_empty
          end
        end

        it "should validate when a correct request is made to GET /message (application/json)" do
          request = Request.new(double("Request", method: :get, url: URI.parse("/message"), request_headers: {"Accept" => "application/json"}))
          response = Response.new(double("Response", status: 200, body: "\"message\": \"Hello World!\"", response_headers: {"Content-Type" => "application/json", "X-My-Message-Header" => "42"}))
          validator = TransactionValidator.new(path: "/message", request_method: :get, content_type: "application/json", parser: parser, validate_request_schema: :when_defined, validate_response_schema: :when_defined)

          aggregate_failures do
            expect(validator.validate(request: request, response: response, error_messages: error_messages)).to be true
            expect(error_messages).to be_empty
          end
        end

        it "should fail validation when an incorrect request is made to GET /message (application/wrong)" do
          request = Request.new(double("Request", method: :get, url: URI.parse("/message"), request_headers: {"Accept" => "application/wrong"}))
          response = Response.new(double("Response", status: 200, body: "{\"message\": \"Hello World!\"}", response_headers: {"Content-Type" => "application/json", "X-My-Message-Header" => "42"}))
          validator = TransactionValidator.new(path: "/message", request_method: :get, content_type: "application/json", parser: parser, validate_request_schema: :when_defined, validate_response_schema: :when_defined)

          aggregate_failures do
            expect(validator.validate(request: request, response: response, error_messages: error_messages)).to be false
            expect(error_messages).to include(a_string_matching(/No candidates for/))
          end
        end

        it "should validate when a correct request is made to PUT /message (text/plain)" do
          request = Request.new(double("Request", method: :put, url: URI.parse("/message"), request_headers: {"Content-Type" => "text/plain", "Accept" => "text/plain"}, body: "All your base are belong to us"))
          response = Response.new(double("Response", status: 204, body: "Hello World!", response_headers: {"Content-Type" => "text/plain", "X-My-Message-Header" => "42"}))
          validator = TransactionValidator.new(path: "/message", request_method: :put, content_type: "text/plain", parser: parser)

          expect(validator.validate(request: request, response: response, error_messages: error_messages)).to be true
          expect(error_messages).to be_empty
        end

        it "should validate when a correct request is made to PUT /message (application/json)" do
          request = Request.new(double("Request", method: :put, url: URI.parse("/message"), request_headers: {"Content-Type" => "application/json", "Accept" => "application/json"}, body: "{\"message\": \"All your base are belong to us.\""))
          response = Response.new(double("Response", status: 204, body: "", response_headers: {"Content-Type" => "application/json", "X-My-Message-Header" => "42"}))
          validator = TransactionValidator.new(path: "/message", request_method: :put, content_type: "application/json", parser: parser, validate_request_schema: :when_defined, validate_response_schema: :when_defined)

          expect(validator.validate(request: request, response: response, error_messages: error_messages)).to be true
          expect(error_messages).to be_empty
        end

        it "should fail validation when an incorrect request is made to POST /message" do
          request = Request.new(double("Request", method: :post, url: URI.parse("/message"), request_headers: {"Content-Type" => "text/plain", "Accept" => "text/plain"}, body: "All your base are belong to us"))
          response = Response.new(double("Response", status: 204, body: "Hello World!", response_headers: {"Content-Type" => "text/plain", "X-My-Message-Header" => "42"}))
          validator = TransactionValidator.new(path: "/message", request_method: :post, content_type: "text/plain", parser: parser)

          expect(validator.validate(request: request, response: response, error_messages: error_messages)).to be false
          expect(error_messages).to include(a_string_matching(/No candidates for/))
        end

        it "should fail validation if the wrong accept header was given in the request" do
          request = Request.new(double("Request", method: :get, url: URI.parse("/message"), request_headers: {"Accept" => "image"}))
          response = Response.new(double("Response", status: 200, body: "Hello World!", response_headers: {"Content-Type" => "text/plain", "X-My-Message-Header" => "42"}))
          validator = TransactionValidator.new(path: "/message", request_method: :get, content_type: "text/plain", parser: parser)

          expect(validator.validate(request: request, response: response, error_messages: error_messages)).to be false
          expect(error_messages).to include(a_string_matching(/No candidates for/))
        end


      end

      context "example 7 - parameters" do
        let(:file) { File.join(examples_path, "07. Parameters.md") }
        it "should validate when a correct request is made to GET /message/99 (text/plain)" do
          request = Request.new(double("Request", method: :get, url: URI.parse("/message/99"), request_headers: {"Accept" => "text/plain"}))
          response = Response.new(double("Response", status: 200, body: "Hello World!", response_headers: {"Content-Type" => "text/plain", "X-My-Message-Header" => "42"}))
          validator = TransactionValidator.new(path: "/message/{id}", request_method: :get, content_type: "text/plain", parser: parser)

          aggregate_failures do
            expect(validator.validate(request: request, response: response, error_messages: error_messages)).to be true
            expect(error_messages).to be_empty
          end
        end

        it "should validate when a correct request is made to GET /message/99 (application/json)" do
          request = Request.new(double("Request", method: :get, url: URI.parse("/message/99"), request_headers: {"Accept" => "application/json"}))
          response = Response.new(double("Response", status: 200, body: "{\"message\": \"Hello World!\"}", response_headers: {"Content-Type" => "application/json", "X-My-Message-Header" => "42"}))
          validator = TransactionValidator.new(path: "/message/{id}", request_method: :get, content_type: "application/json", parser: parser, validate_request_schema: :when_defined, validate_response_schema: :when_defined)

          aggregate_failures do
            expect(validator.validate(request: request, response: response, error_messages: error_messages)).to be true
            expect(error_messages).to be_empty
          end
        end

        it "should validate when a correct request is made to PUT /message/99 (text/plain)" do
          request = Request.new(double("Request", method: :put, url: URI.parse("/message/99"), request_headers: {"Content-Type" => "text/plain", "Accept" => "text/plain"}, body: "All your base are belong to us"))
          response = Response.new(double("Response", status: 204, body: "Hello World!", response_headers: {"Content-Type" => "text/plain", "X-My-Message-Header" => "42"}))
          validator = TransactionValidator.new(path: "/message/{id}", request_method: :put, content_type: "text/plain", parser: parser)

          aggregate_failures do
            expect(validator.validate(request: request, response: response, error_messages: error_messages)).to be true
            expect(error_messages).to be_empty
          end
        end

        it "should validate when a correct request is made to PUT /message/99 (application/json)" do
          request = Request.new(double("Request", method: :put, url: URI.parse("/message/99"), request_headers: {"Content-Type" => "application/json", "Accept" => "application/json"}, body: "{\"message\": \"All your base are belong to us.\"}"))
          response = Response.new(double("Response", status: 204, body: "", response_headers: {"Content-Type" => "application/json", "X-My-Message-Header" => "42"}))
          validator = TransactionValidator.new(path: "/message/{id}", request_method: :put, content_type: "application/json", parser: parser, validate_request_schema: :when_defined, validate_response_schema: :when_defined)

          aggregate_failures do
            expect(validator.validate(request: request, response: response, error_messages: error_messages)).to be true
            expect(error_messages).to be_empty
          end
        end

        it "should fail validation when an incorrect request is made to PUT /message/99 (application/wrong)" do
          request = Request.new(double("Request", method: :put, url: URI.parse("/message/99"), request_headers: {"Content-Type" => "application/wrong", "Accept" => "application/wrong"}, body: "{\"message\": \"All your base are belong to us.\"}"))
          response = Response.new(double("Response", status: 204, body: "", response_headers: {"Content-Type" => "application/json", "X-My-Message-Header" => "42"}))
          validator = TransactionValidator.new(path: "/message/{id}", request_method: :put, content_type: "application/json", parser: parser, validate_request_schema: :when_defined, validate_response_schema: :when_defined)

          aggregate_failures do
            expect(validator.validate(request: request, response: response, error_messages: error_messages)).to be false
            expect(error_messages).to include(a_string_matching(/No candidates for/))
          end
        end

        it "should validate when a correct request is made to GET /messages?limit=10 (application/json)" do
          request = Request.new(double("Request", method: :get, url: URI.parse("/messages?limit=10"), request_headers: {"Accept" => "application/json"}))
          response = Response.new(double("Response", status: 200, body: "{\"message\": \"Hello World!\"}", response_headers: {"Content-Type" => "application/json", "X-My-Message-Header" => "42"}))
          validator = TransactionValidator.new(path: "/messages{?limit}", request_method: :get, content_type: "application/json", parser: parser, validate_request_schema: :when_defined, validate_response_schema: :when_defined)

          aggregate_failures do
            expect(validator.validate(request: request, response: response, error_messages: error_messages)).to be true
            expect(error_messages).to be_empty
          end
        end

        it "should validate when a correct request is made to GET /messages (application/json)" do
          request = Request.new(double("Request", method: :get, url: URI.parse("/messages"), request_headers: {"Accept" => "application/json"}))
          response = Response.new(double("Response", status: 200, body: "{\"message\": \"Hello World!\"}", response_headers: {"Content-Type" => "application/json", "X-My-Message-Header" => "42"}))
          validator = TransactionValidator.new(path: "/messages{?limit}", request_method: :get, content_type: "application/json", parser: parser, validate_request_schema: :when_defined, validate_response_schema: :when_defined)

          aggregate_failures do
            expect(validator.validate(request: request, response: response, error_messages: error_messages)).to be true
            expect(error_messages).to be_empty
          end
        end


      end

      context "example 8 - attributes" do
        let(:file) { File.join(examples_path, "08. Attributes.md") }
        it "should validate when a correct request is made to GET /coupons/99 (application/json)" do
          request = Request.new(double("Request", method: :get, url: URI.parse("/coupons/99"), request_headers: {"Accept" => "application/json"}))
          response = Response.new(double("Response", status: 200, body: {"id" => "anystring"}, response_headers: {"Content-Type" => "application/json"}))
          validator = TransactionValidator.new(path: "/coupons/{id}", request_method: :get, content_type: "application/json", parser: parser)

          aggregate_failures do
            expect(validator.validate(request: request, response: response, error_messages: error_messages)).to be true
            expect(error_messages).to be_empty
          end
        end

        it "should fail validation when a correct request is made to GET /coupons/99 (application/json) but the response provides a string in the created field" do
          request = Request.new(double("Request", method: :get, url: URI.parse("/coupons/99"), request_headers: {"Accept" => "application/json"}))
          response = Response.new(double("Response", status: 200, body: {"id" => "anystring", "created" => "12121212"}, response_headers: {"Content-Type" => "application/json"}))
          validator = TransactionValidator.new(path: "/coupons/{id}", request_method: :get, content_type: "application/json", parser: parser)

          aggregate_failures do
            expect(validator.validate(request: request, response: response, error_messages: error_messages)).to be false
            expect(error_messages).to include(a_string_matching(/string did not match the following type: number/))
          end
        end
      end

      context "example 9 - advanced attributes" do
        let(:file) { File.join(examples_path, "09. Advanced Attributes.md") }
        it "should validate when a correct request is made to GET /coupons/99 (application/json)" do
          request = Request.new(double("Request", method: :get, url: URI.parse("/coupons/99"), request_headers: {"Accept" => "application/json"}))
          response = Response.new(double("Response", status: 200, body: {"id" => "anystring"}, response_headers: {"Content-Type" => "application/json"}))
          validator = TransactionValidator.new(path: "/coupons/{id}", request_method: :get, content_type: "application/json", parser: parser)

          aggregate_failures do
            expect(validator.validate(request: request, response: response, error_messages: error_messages)).to be true
            expect(error_messages).to be_empty
          end
        end

        it "should fail validation when a correct request is made to GET /coupons/99 (application/json) but the response provides a string in the created field" do
          request = Request.new(double("Request", method: :get, url: URI.parse("/coupons/99"), request_headers: {"Accept" => "application/json"}))
          response = Response.new(double("Response", status: 200, body: {"id" => "anystring", "created" => "12121212"}, response_headers: {"Content-Type" => "application/json"}))
          validator = TransactionValidator.new(path: "/coupons/{id}", request_method: :get, content_type: "application/json", parser: parser)

          aggregate_failures do
            expect(validator.validate(request: request, response: response, error_messages: error_messages)).to be false
            expect(error_messages).to include(a_string_matching(/string did not match the following type: number/))
          end
        end

        it "should validate when a correct request is made to GET /coupons (application/json)" do
          request = Request.new(double("Request", method: :get, url: URI.parse("/coupons"), request_headers: {"Accept" => "application/json"}))
          response = Response.new(double("Response", status: 200, body: [{"id" => "anystring"}], response_headers: {"Content-Type" => "application/json"}))
          validator = TransactionValidator.new(path: "/coupons{?limit}", request_method: :get, content_type: "application/json", parser: parser)

          aggregate_failures do
            expect(validator.validate(request: request, response: response, error_messages: error_messages)).to be true
            expect(error_messages).to be_empty
          end
        end

        it "should fail validation when a correct request is made to GET /coupons (application/json) but the response contains a single object" do
          request = Request.new(double("Request", method: :get, url: URI.parse("/coupons"), request_headers: {"Accept" => "application/json"}))
          response = Response.new(double("Response", status: 200, body: {"id" => "anystring"}, response_headers: {"Content-Type" => "application/json"}))
          validator = TransactionValidator.new(path: "/coupons{?limit}", request_method: :get, content_type: "application/json", parser: parser)

          aggregate_failures do
            expect(validator.validate(request: request, response: response, error_messages: error_messages)).to be false
            expect(error_messages).to include(a_string_matching(/object did not match the following type: array/))
          end
        end

        it "should validate when a correct request is made to POST /coupons (application/json)" do
          request = Request.new(double("Request", method: :post, url: URI.parse("/coupons"), request_headers: {"Accept" => "application/json", "Content-Type" => "application/json"}, body: "{\"percent_off\": 25, \"redeem_by\": 121212}"))
          response = Response.new(double("Response", status: 200, body: {"id" => "anystring", "percent_off" => 25, "redeem_by" => 121212 }, response_headers: {"Content-Type" => "application/json"}))
          validator = TransactionValidator.new(path: "/coupons{?limit}", request_method: :post, content_type: "application/json", parser: parser, validate_request_schema: :when_defined)

          aggregate_failures do
            expect(validator.validate(request: request, response: response, error_messages: error_messages)).to be true
            expect(error_messages).to be_empty
          end
        end


      end

      context "example 10 - data structures" do
        let(:file) { File.join(examples_path, "10. Data Structures.md") }
        it "should validate when a correct request is made to GET /coupons/99 (application/json)" do
          request = Request.new(double("Request", method: :get, url: URI.parse("/coupons/99"), request_headers: {"Accept" => "application/json"}))
          response = Response.new(double("Response", status: 200, body: {"id" => "anystring"}, response_headers: {"Content-Type" => "application/json"}))
          validator = TransactionValidator.new(path: "/coupons/{id}", request_method: :get, content_type: "application/json", parser: parser)

          aggregate_failures do
            expect(validator.validate(request: request, response: response, error_messages: error_messages)).to be true
            expect(error_messages).to be_empty
          end
        end

        it "should fail validation when a correct request is made to GET /coupons/99 (application/json) but the response provides a string in the created field" do
          request = Request.new(double("Request", method: :get, url: URI.parse("/coupons/99"), request_headers: {"Accept" => "application/json"}))
          response = Response.new(double("Response", status: 200, body: {"id" => "anystring", "created" => "12121212"}, response_headers: {"Content-Type" => "application/json"}))
          validator = TransactionValidator.new(path: "/coupons/{id}", request_method: :get, content_type: "application/json", parser: parser)

          aggregate_failures do
            expect(validator.validate(request: request, response: response, error_messages: error_messages)).to be false
            expect(error_messages).to include(a_string_matching(/string did not match the following type: number/))
          end
        end

      end

      context "example 11 - resource model" do
        let(:file) { File.join(examples_path, "11. Resource Model.md") }
        it "should validate when a correct request is made to GET /message (application/vnd.siren+json)" do
          request = Request.new(double("Request", method: :get, url: URI.parse("/message"), request_headers: {"Accept" => "application/vnd.siren+json"}))
          response = Response.new(double("Response", status: 200, body: [{"id" => "anystring"}], response_headers: {"Content-Type" => "application/vnd.siren+json", "Location" => "http://api.acme.com/message"}))
          validator = TransactionValidator.new(path: "/message", request_method: :get, content_type: "application/vnd.siren+json", parser: parser, validate_response_schema: :when_defined)

          aggregate_failures do
            expect(validator.validate(request: request, response: response, error_messages: error_messages)).to be true
            expect(error_messages).to be_empty
          end
        end
      end

      context "example 13 - named endpoints" do
        let(:file) { File.join(examples_path, "13. Named Endpoints.md") }
        it "should validate when a correct request is made to POST /messages (application/json)" do
          request = Request.new(double("Request", method: :post, url: URI.parse("/messages"), request_headers: {"Accept" => "application/json", "Content-Type" => "application/json"}, body: "{\"message\": \"Hello World\"}"))
          response = Response.new(double("Response", status: 201, body: {}, response_headers: {"Content-Type" => "application/json", "Location" => "Anything"}))
          validator = TransactionValidator.new(path: "/messages", request_method: :post, content_type: "application/json", parser: parser, validate_request_schema: :when_defined, validate_response_schema: :when_defined)

          aggregate_failures do
            expect(validator.validate(request: request, response: response, error_messages: error_messages, options: {ignore_response_header_values: ["Location"]})).to be true
            expect(error_messages).to be_empty
          end
        end
      end

      context "example 14 - json schema" do
        let(:file) { File.join(examples_path, "14. JSON Schema.md") }
        it "should validate when a correct request is made to GET /notes/99 (application/json)" do
          request = Request.new(double("Request", method: :get, url: URI.parse("/notes/99"), request_headers: {"Accept" => "application/json", "Content-Type" => "application/json"}))
          response = Response.new(double("Response", status: 200, body: {}, response_headers: {"Content-Type" => "application/json"}))
          validator = TransactionValidator.new(path: "/notes/{id}", request_method: :get, content_type: "application/json", parser: parser)

          aggregate_failures do
            expect(validator.validate(request: request, response: response, error_messages: error_messages)).to be true
            expect(error_messages).to be_empty
          end
        end

        it "should validate when a correct request is made to PATCH /notes/99 (application/json) with valid data" do
          request = Request.new(double("Request", method: :patch, url: URI.parse("/notes/99"), request_headers: {"Accept" => "application/json", "Content-Type" => "application/json"}, body: "{\"tags\":[\"tag1\"]}"))
          response = Response.new(double("Response", status: 204, body: {}, response_headers: {"Content-Type" => "application/json"}))
          validator = TransactionValidator.new(path: "/notes/{id}", request_method: :patch, content_type: "application/json", parser: parser, validate_response_schema: :when_defined)

          aggregate_failures do
            expect(validator.validate(request: request, response: response, error_messages: error_messages)).to be true
            expect(error_messages).to be_empty
          end
        end

        it "should fail validation when an incorrect request is made to PATCH /notes/99 (application/json) with numeric tags" do
          request = Request.new(double("Request", method: :patch, url: URI.parse("/notes/99"), request_headers: {"Accept" => "application/json", "Content-Type" => "application/json"}, body: "{\"tags\":[99]}"))
          response = Response.new(double("Response", status: 204, body: {}, response_headers: {"Content-Type" => "application/json"}))
          validator = TransactionValidator.new(path: "/notes/{id}", request_method: :patch, content_type: "application/json", parser: parser, validate_response_schema: :when_defined)

          aggregate_failures do
            expect(validator.validate(request: request, response: response, error_messages: error_messages)).to be false
            expect(error_messages).to include(a_string_matching(/integer did not match the following type: string/))
          end
        end

      end

      context "Gist Fox API + Auth" do
        let(:file) { File.join(examples_path, "Gist Fox API + Auth.md") }
      end

      context "Gist Fox API" do
        let(:file) { File.join(examples_path, "Gist Fox API.md") }
      end

      context "Polls API" do
        let(:file) { File.join(examples_path, "Polls API.md") }
      end

      context "Polls Hypermedia API" do
        let(:file) { File.join(examples_path, "Polls Hypermedia API.md") }
      end

      context "Real World API" do
        let(:file) { File.join(examples_path, "Real World API.md") }
      end
    end
  end
end
