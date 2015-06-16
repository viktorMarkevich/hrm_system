ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'capybara/rspec'
require 'factory_girl'
require 'capybara/rails'

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end

RSpec.configure do |config|

  config.include Rails.application.routes.url_helpers
  config.infer_spec_type_from_file_location!
  config.use_transactional_fixtures = false

  Capybara.configure do |config|
    config.run_server = false
    config.default_driver = :selenium
    config.app_host = 'localhost:3000/'
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
    config.include Capybara::DSL
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

end