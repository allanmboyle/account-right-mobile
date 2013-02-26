begin
  require 'rspec/core/rake_task'

  desc "Exercises specifications"
  ::RSpec::Core::RakeTask.new(:spec)
rescue
  desc 'spec rake task not available (RSpec not installed)'
  task :spec do
    abort 'RSpec rake task is not available. Be sure to install RSpec as a gem or plugin'
  end
end
