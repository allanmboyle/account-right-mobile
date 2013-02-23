desc "Exercises specifications with coverage analysis"
task :coverage do
  ENV["coverage"] = "true"
  Rake::Task[:spec].invoke
end
