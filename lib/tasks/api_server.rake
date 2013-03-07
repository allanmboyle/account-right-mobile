require 'http_stub/start_server_rake_task'

::HttpStub::StartServerRakeTask.new(name: :api_stub_server, port: 3003)

namespace :api_stub_server do

  desc "Starts a stub API server as a background process"
  task :start do
    api_stub_server.start!
  end

  desc "Stops a running stub API server"
  task :stop do
    api_stub_server.stop!
  end

  desc "Displays the status of a stub API server process"
  task :status do
    puts "api_stub_server is #{api_stub_server.status}"
  end

  def api_stub_server
    AccountRightMobile::Services::ApiStubServer.new(port: 3003)
  end

end
