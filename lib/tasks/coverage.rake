desc "Exercises specifications with coverage analysis"
task :coverage do
  ENV["coverage"] = "true"
  Rake::Task[:spec].invoke
end

namespace :coverage do

  desc "Deletes generated coverage artifacts"
  task(:clean) { rm_rf("#{Rails.root}/coverage") }

end
