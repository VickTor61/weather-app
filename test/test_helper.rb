ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require 'minitest/mock'
require 'webmock/minitest'
require "mocha/minitest"


module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    include ActiveSupport::Testing::TimeHelpers
    WebMock.disable_net_connect!(allow_localhost: true)
  end
end
