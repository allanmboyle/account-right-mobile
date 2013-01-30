desc "All metrics checks"
task(:metrics => "metrics:coffeescript")

namespace(:metrics) do

  NODE_BIN_DIR = Rails.root.join("node_modules", ".bin")

  desc "CoffeeScript metrics checks"
  task("coffeescript" => "npm:install") do
    coffeelint_script_location = NODE_BIN_DIR.join("coffeelint")
    coffeescript_files_directory = Rails.root.join("app", "assets", "javascripts")
    coffeelint_config_file = Rails.root.join("config", "coffeelint.json")
    output = execute_with_logging "#{coffeelint_script_location} -f #{coffeelint_config_file} #{coffeescript_files_directory} -r -q"
    raise "Coffeelint metrics check failed" unless (output =~ /0 errors/i) && (output =~ /0 warnings/i)
  end

end
