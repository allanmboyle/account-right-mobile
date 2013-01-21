desc "All metrics checks"
task(:metrics => %w{metrics:coffeescript})

namespace(:metrics) do

  desc "Coffeescript metrics checks"
  task(:coffeescript) do
    coffeelint_script_location = Rails.root.join("node_modules", ".bin", "coffeelint")
    coffeescript_files_directory = Rails.root.join("app", "assets", "javascripts")
    coffeelint_config_file = Rails.root.join("config", "coffeelint.json")
    puts "Running coffeelint code analysis..."
    output = `#{coffeelint_script_location} -f #{coffeelint_config_file} #{coffeescript_files_directory} -r -q`
    puts output
    raise "Coffeelint metrics check failed" unless (output =~ /0 errors/i) && (output =~ /0 warnings/i)
  end

end
