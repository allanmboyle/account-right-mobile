namespace :servers  do

  desc "Starts servers necessary for acceptance"
  task :start => %w{ rails_server:start oauth_stub_server:start }

  desc "Stops servers necessary for acceptance"
  task :stop => %w{ rails_server:stop oauth_stub_server:stop }

end
