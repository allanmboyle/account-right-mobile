namespace(:node) do

  task(:environment) do
    begin
      execute_with_logging "node -v"
    rescue
      raise "Node.js must be installed"
    end
  end

end

namespace(:npm) do

  task(:environment) do
    NPM_INSTALLED = begin
      execute_with_logging "npm -v"
      puts "NPM detected"
      true
    rescue
      puts "NPM not detected"
      false
    end
  end

  desc "Updates npm packages when npm has been installed"
  task(:install => %w{ npm:environment }) do
    if NPM_INSTALLED
      execute_with_logging "npm install"
    end
  end

end
