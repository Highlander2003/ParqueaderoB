ENV["RAILS_ENV"] ||= "test"
if ENV["RAILS_ENV"] == "test" && $PROGRAM_NAME == "bin/rails"
  require "simplecov"
  SimpleCov.start :rails do
    enable_coverage :branch
    minimum_coverage 95
  end
  puts "required simplecov"
end

require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
