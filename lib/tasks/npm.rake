namespace(:npm) do

  desc "Performs npm install"
  task(:install) do
    puts "Performing npm install..."
    puts `npm install`
  end

end
