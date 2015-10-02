source 'https://rubygems.org'

ruby '2.2.2'
gem 'rails', '4.2.1'
gem 'pg'
gem 'uglifier', '>= 1.3.0'
gem 'therubyracer', platforms: :ruby
gem 'jquery-rails'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'dotenv-rails'
gem 'devise'
gem 'devise_invitable', '~> 1.3.4'
gem 'haml-rails'
gem 'less-rails'
gem 'twitter-bootstrap-rails'
gem 'twitter-bootswatch-rails', '~> 3.3.4'
gem 'twitter-bootswatch-rails-helpers'
gem 'paperclip', '~> 4.2'
gem 'activeadmin', '~> 1.0.0.pre1'
gem 'paranoia', '~> 2.0'
gem 'kaminari'
gem 'cancancan', '~> 1.10'
gem 'simple_calendar', '~> 1.1.0'
gem 'rufus-scheduler', '~> 3.1.3' #awesome scheduler gem!!!
gem 'coffee-rails', '~> 4.1.0'

gem 'capistrano', '~> 3.4'
gem 'capistrano-rails', '~> 1.1.3'

group :development do
  gem 'letter_opener'
end

group :staging, :production do
  gem 'unicorn'
  gem 'unicorn-rails'
end

group :development, :test do
  gem 'rspec-rails', '~> 3.0'
end

group :test do
  gem 'cucumber-rails', require: false
  gem 'capybara'
  gem 'factory_girl_rails', '~> 4.0'
  gem 'simplecov', require: false
  gem 'database_cleaner'
  gem 'shoulda-matchers', require: false
end
