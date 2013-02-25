namespace :rails_server do

  desc "Starts a Rails server as a background process"
  task :start do
    rails_server.start!
  end

  desc "Stops a running Rails server"
  task :stop do
    rails_server.stop!
  end

  desc "Displays the status of a Rails server process"
  task :status do
    puts "rails server is #{rails_server.status}"
  end

  def rails_server
    AccountRightMobile::Services::RailsServer.new(environment: ENV["e"] || "test", port: 3001)
  end

end
