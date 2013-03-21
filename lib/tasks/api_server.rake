require 'http_stub/rake/task_generators'
require 'http_server_manager/rake/task_generators'

::HttpStub::Rake::StartServerTask.new(name: :api_stub_server, port: 3003)

namespace :api_stub_server do

  ::HttpServerManager::Rake::ServerTasks.new(AccountRightMobile::Services::ApiStubServer.new(port: 3003))

end
