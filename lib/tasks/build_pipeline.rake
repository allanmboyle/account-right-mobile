desc "Deletes generated artifacts"
task(:clean => %w{ assets:clean jasmine:clean })

desc "Compile pipeline stage"
task(:compile => "assets:precompile")

desc "Unit Test pipeline stage"
task(:unit => "jasmine")

desc "Commit pipeline phase"
task(:commit => %w{clean compile metrics})

desc "Acceptance pipeline stage, e=? to target environment"
task :acceptance do
  environment = ENV["e"] || "development"
  environment_configs = YAML.load_file(Rails.root.join("config", "acceptance.yml"))
  ENV["host"] = environment_configs[environment]["host"]
  puts "Executing acceptance tests on #{environment} environment"
  Rake::Task[:cucumber].invoke()
end
