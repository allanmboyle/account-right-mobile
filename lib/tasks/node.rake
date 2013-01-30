namespace(:node) do

  task(:environment) do
    output = execute_with_logging "node -v"
    raise "Node.js must be installed" if output.contains_execution_error?
  end

end

namespace(:npm) do

  task(:environment) do
    output = execute_with_logging "npm -v"
    NPM_INSTALLED = !output.contains_execution_error?
  end

  desc "Updates npm packages when npm has been installed"
  task(:install => %w{ npm:environment }) do
    if NPM_INSTALLED
      execute_with_logging "npm install"
    end
  end

end
