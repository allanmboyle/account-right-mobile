require 'http/stub/start_server_rake_task'
Http::Stub::StartServerRakeTask.new(name: :oauth_server, port: 3002)

namespace :oauth_server do

  desc "Starts a stub oAuth server as a background process"
  task :start do
    oauth_server.start!
  end

  desc "Stops a running stub oAuth server"
  task :stop do
    oauth_server.stop!
  end

  def oauth_server
    AccountRightMobile::OAuthServer.new(port: 3002)
  end

end
