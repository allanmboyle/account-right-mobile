require 'http_stub/start_server_rake_task'

::HttpStub::StartServerRakeTask.new(name: :oauth_stub_server, port: 3002)

namespace :oauth_stub_server do

  desc "Starts a stub oAuth server as a background process"
  task :start do
    oauth_stub_server.start!
  end

  desc "Stops a running stub oAuth server"
  task :stop do
    oauth_stub_server.stop!
  end

  def oauth_stub_server
    AccountRightMobile::OAuthStubServer.new(port: 3002)
  end

end
