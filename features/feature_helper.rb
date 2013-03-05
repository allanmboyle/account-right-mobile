# Initialize Rails
require File.expand_path("../../config/environment", __FILE__)

Bundler.setup(:test)
require 'immutable_struct'
require 'capybara'

require File.expand_path('../acceptance', __FILE__)
%w{ support step_definitions }.each do |dir|
  Dir[File.expand_path("../#{dir}/**/*.rb", __FILE__)].each { |file| require file }
end
