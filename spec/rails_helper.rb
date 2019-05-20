require 'simplecov'
SimpleCov.start

ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../../config/environment', __FILE__)
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

abort('The Rails environment is running in production mode!') if Rails.env.production?

FactoryBot.allow_class_lookup = false
require 'rspec/rails'
require 'factory_bot'
require 'database_cleaner'
require 'shoulda/matchers'

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|

  config.include Rails.application.routes.url_helpers

  config.order = 'random'

  config.infer_spec_type_from_file_location!

  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.include FactoryBot::Syntax::Methods

  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Warden::Test::Helpers

  config.include(Shoulda::Matchers::ActiveModel, type: :model)
  config.include(Shoulda::Matchers::ActiveRecord, type: :model)

end