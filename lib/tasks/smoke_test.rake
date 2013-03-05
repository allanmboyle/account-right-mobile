begin
  require 'cucumber/rake/task'

  vendored_cucumber_bin = Dir["#{Rails.root}/vendor/{gems,plugins}/cucumber*/bin/cucumber"].first

  namespace :smoke_test do

    [:uat, :production].each do |environment|
      Cucumber::Rake::Task.new({environment => 'db:test:prepare'}, "Execute smoke tests against #{environment}") do |t|
        t.binary = vendored_cucumber_bin
        t.fork = true # You may get faster startup if you set this to false
        t.profile = "smoke_#{environment}"
      end
    end

  end

rescue LoadError
  desc 'cucumber rake task not available (cucumber not installed)'
  task :cucumber do
    abort 'Cucumber rake task is not available. Be sure to install cucumber as a gem or plugin'
  end
end
