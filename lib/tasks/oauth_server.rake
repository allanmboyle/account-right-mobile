require 'http_stub/rake/task_generators'
require 'http_server_manager/rake/task_generators'

::HttpStub::Rake::StartServerTask.new(name: :oauth_stub_server, port: 3002)

namespace :oauth_stub_server do

  ::HttpServerManager::Rake::ServerTasks.new(AccountRight::OAuth::Stub::Server.new(port: 3002))

end
