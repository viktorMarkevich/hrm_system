source 'https://rubygems.org'

ruby '2.4.0'
gem 'rails', '5.0.1'
gem 'pg'
gem 'uglifier', '>= 1.3.0'
gem 'therubyracer', platforms: :ruby
gem 'jquery-rails'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'dotenv-rails'
gem 'devise'
gem 'devise_invitable', '~> 1.7.0'
gem 'haml-rails'
gem 'paperclip', '~> 4.2'
gem 'activeadmin', '~> 1.0.0.pre4'
gem 'inherited_resources', git: 'https://github.com/activeadmin/inherited_resources'
gem 'jquery-ui-rails', '~> 4.2.1'
gem 'paranoia', '~> 2.0'
gem 'kaminari'
gem 'cancancan', '~> 1.10'
gem 'simple_calendar', '~> 1.1.0'
gem 'rufus-scheduler', '~> 3.1.3' #awesome scheduler gem!!!
gem 'coffee-rails', '~> 4.1.0'

gem 'capistrano', '~> 3.4'
gem 'capistrano-rails', '~> 1.1.3'
gem 'capistrano-rvm'

gem 'yomu'

gem 'docx', '~> 0.2.07', :require => ["docx"]
gem 'bootstrap-sass'
gem 'sass-rails'

gem 'rubyzip', '~> 1.1.0'
gem 'axlsx', '2.1.0.pre'
gem 'axlsx_rails'
gem 'acts_as_xlsx', git: "git://github.com/straydogstudio/acts_as_xlsx.git"
group :development do
  gem 'letter_opener'
end

group :staging, :production do
  gem 'unicorn'
  gem 'unicorn-rails'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'rails-controller-testing'
end

group :test do
  gem 'cucumber-rails', require: false
  gem 'capybara'
  gem 'factory_girl_rails'
  gem 'simplecov', require: false
  gem 'database_cleaner'
  gem 'shoulda-matchers', require: false
end
