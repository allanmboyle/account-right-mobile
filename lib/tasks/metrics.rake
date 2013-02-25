desc "All metrics checks"
task(:metrics => "metrics:coffeescript")

namespace(:metrics) do

  desc "CoffeeScript metrics checks"
  task("coffeescript" => %w{ node:required npm:install }) do
    coffeelint_script_path = AccountRightMobile::Build::Npm.root.join("coffeelint", "bin", "coffeelint")
    coffeescript_files_dir = Rails.root.join("app", "assets", "javascripts")
    coffeelint_config_path = Rails.root.join("config", "coffeelint.json")
    output = execute_with_logging "node #{coffeelint_script_path} -f #{coffeelint_config_path} #{coffeescript_files_dir} -r -q"
    fail "Coffeelint metrics check failed" unless (output =~ /0 errors/i) && (output =~ /0 warnings/i)
  end

end
