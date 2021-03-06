module Stubs
  ALL = %w{ oauth_stub_server api_stub_server }
end

namespace :stubs do

  desc "Starts all stubs servers"
  task :start => Stubs::ALL.collect { |name| "#{name}:start" }

  desc "Stops any running stubs servers"
  task :stop => Stubs::ALL.collect { |name| "#{name}:stop" }

  desc "Restarts all stubs servers"
  task :restart => Stubs::ALL.collect { |name| "#{name}:restart" }

  desc "Displays the status of the stubs servers"
  task :status => Stubs::ALL.collect { |name| "#{name}:status" }

end
