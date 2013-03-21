require 'http_server_manager/rake/task_generators'

namespace :rails_server do

  ::HttpServerManager::Rake::ServerTasks.new(
      AccountRightMobile::Services::RailsServer.new(environment: ENV["RAILS_ENV"] || "test", port: 3001)
  )

end
