namespace :rails_server do

  desc "Starts a Rails server as a background process"
  task :start do
    rails_server.start!
  end

  desc "Stops a running Rails server"
  task :stop do
    rails_server.stop!
  end

  def rails_server
    ENV["app_host"] = "localhost:3001"
    AccountRightMobile::RailsServer.new(environment: ENV["e"] || "test", port: 3001)
  end

end
