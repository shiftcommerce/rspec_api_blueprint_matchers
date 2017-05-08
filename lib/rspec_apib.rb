# frozen_string_literal: true
require "rspec_apib/version"
require "rspec_apib/parser"
require "rspec_apib/extractors"
require "rspec_apib/transaction_validator"
require "rspec_apib/rspec"
require "rspec_apib/config"
require "rspec_apib/request"
require "rspec_apib/response"
module RSpecApib
  ROOT_THREAD_VARS = :rspec_apib
  # The global configuration object
  # If a block is passed into this method, it is yielded with
  # the config object and all actions are performed from within the
  # block as a batch - any action(s) that then need performing after
  # a reconfigure are done once only.
  def self.config
    return config_instance unless block_given?
    config_instance.batch_configure do |config|
      yield(config)
    end
  end

  def self.normalize_request(request)
    Request.new request
  end

  def self.normalize_response(response)
    Response.new response
  end

  # Global storage per thread for the gems to use where required.
  # @return [Hash] A hash which the caller is free to modify at will
  def self.root_thread_vars
    Thread.current[ROOT_THREAD_VARS] ||= {}
  end

  def self.config_instance
    root_thread_vars[:config_instance] ||= RSpecApib::Config.new
  end

end
