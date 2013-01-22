namespace(:npm) do

  task(:setup) do
    NODE_BIN_DIR = Rails.root.join("node_modules", ".bin")
  end

  desc "Performs npm install"
  task(:install => "npm:setup") do
    puts "Performing npm install..."
    puts `npm install`
  end

end
