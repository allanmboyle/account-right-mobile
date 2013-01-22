namespace(:compile) do

  directory "tmp/javascripts"

  task(:clean) do
    puts "Cleaning artifacts..."
    FileUtils.rm_rf("tmp/javascripts")
  end

  desc "All compilation steps"
  task(:all => "compile:coffee-script")

  desc "CoffeeScript compilation"
  task("coffee-script" => %w{ tmp/javascripts npm:install }) do
    puts "Compiling CoffeeScript..."
    coffee_compiler_location = NODE_BIN_DIR.join("coffee")
    source_directory = Rails.root.join("app", "assets", "javascripts")
    destination_directory = Rails.root.join("tmp", "javascripts")
    output = execute_with_logging "#{coffee_compiler_location} --lint --compile --output #{destination_directory} #{source_directory} 2>&1"
    raise "CoffeeScript compilation failed" if (output =~ /error/i) || (output =~ /warning/i)
  end

end
