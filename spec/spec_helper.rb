require "bundler/setup"
require "kycaid"
require "vcr"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/kycaid_cassettes"
  config.hook_into :webmock
  config.ignore_localhost = true
  config.default_cassette_options = { :match_requests_on => [:method, :uri, :body], :record => :new_episodes }
  config.configure_rspec_metadata!
end

KYCAID.configure