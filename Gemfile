source 'http://rubygems.org'

ruby '1.9.3'

gem 'bundler', '~> 1.3.5'

gem 'rails', '3.2.13'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

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

gem 'account-right-mobile-configuration', git: 'git@github.com:MYOB-Technology/account-right-mobile-configuration.git', tag: 'v0.2.13'
gem 'json'
gem 'httparty', '~> 0.10.2'

group :test do
  gem 'immutable_struct', '~> 1.1.0'
  gem 'wait_until', '~> 0.0.1'

  gem 'rspec-rails', '~> 2.13.0'
  gem 'simplecov', '~> 0.7.1'

  gem 'cucumber-rails', '~> 1.3', require: false
  gem 'selenium-webdriver', '~> 2.29'

  # For debugging purposes - should never be pushed
  # gem 'ruby-debug19'
end

group :stub_services do
  gem 'faker', '~> 1.1.2'
  gem 'http_server_manager', '~> 0.2.0'
  gem 'http_stub', '~> 0.7.3'
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

gem 'newrelic_rpm'
