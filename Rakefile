#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require File.expand_path('../lib/account_right_mobile/build', __FILE__)
require File.expand_path('../lib/account_right_mobile/services', __FILE__)

AccountRightMobile::Application.load_tasks

task :default => [:commit, :acceptance] do
  Rake::Task["assets:clean"].execute
end
