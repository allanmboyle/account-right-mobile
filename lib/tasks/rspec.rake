require 'rspec/core/rake_task'

desc "Exercises specifications"
::RSpec::Core::RakeTask.new(:spec)
