namespace(:node) do

  task(:required) do
    begin
      execute_with_logging("node -v")
    rescue
      raise "Node.js must be installed"
    end
  end

end

namespace(:npm) do

  NPM_BIN_DIR = Rails.root.join("node_modules", ".bin")

  task(:environment) do
    NPM_INSTALLED = begin
      execute_with_logging("npm -v")
      puts "Node.js npm detected"
      true
    rescue
      puts "Node.js npm not detected"
      false
    end
  end

  desc "Fails should npm not be installed"
  task(:required => "npm:environment") do
    raise "Node.js npm must be installed" unless NPM_INSTALLED
  end

  desc "Updates npm packages when npm has been installed"
  task(:install => "npm:environment") do
    execute_with_logging("npm install") if NPM_INSTALLED
  end

end
