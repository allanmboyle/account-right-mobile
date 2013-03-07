namespace :servers  do

  desc "Starts servers necessary for acceptance"
  task :start => %w{ rails_server:start oauth_stub_server:start api_stub_server:start }

  desc "Stops servers necessary for acceptance"
  task :stop do
    exceptions = []
    %w{ rails_server:stop oauth_stub_server:stop api_stub_server:stop }.each do |task_name|
      begin
        Rake::Task[task_name].invoke
      rescue => exc
        exceptions << exc
      end
    end
    fail exceptions.map { |exc| exc.to_s }.join("\n") unless exceptions.empty?
  end

  desc "Status of servers necessary for acceptance"
  task :status => %w{ rails_server:status oauth_stub_server:status api_stub_server:status }

end
