namespace(:npm) do

  task(:environment) do
    output = execute_with_logging "npm -v"
    NPM_INSTALLED = output !~ /no such file or directory/i && output !~ /command not found/
  end

  task(:setup) do
    NODE_BIN_DIR = Rails.root.join("node_modules", ".bin")
  end

  desc "Updates npm packages when npm has been installed"
  task(:install => %w{ npm:environment npm:setup }) do
    if NPM_INSTALLED
      execute_with_logging "npm install"
    end
  end

end
