source ENV['GEMFURY_URL'] if ENV['GEMFURY_URL']
source 'http://rubygems.org'

ruby '1.9.3'

gem 'rails', '3.2.11'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'account-right-mobile-configuration', '0.2.10' if ENV['GEMFURY_URL']
gem 'deep_merge', '~> 1.0.0', require: 'deep_merge/rails_compat'
gem 'json'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

group :test do
  gem 'immutable_struct', '~> 1.1.0'

  gem 'rspec-rails', '~> 2.13.0'
  gem 'simplecov', '~> 0.7.1'

  gem 'cucumber-rails', '~> 1.3', require: false
  gem 'selenium-webdriver', '~> 2.29'

  # For debugging purposes - should never be pushed
  # gem 'ruby-debug19'
end

gem 'sys-proctree', '~> 0.0.4', require: 'sys/proctree'
gem 'http_stub', '~> 0.6.0'
gem 'http_server_manager', '~> 0.1.1'
gem 'wait_until', '~> 0.0.1'
gem 'httparty', '~> 0.10.2'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'
