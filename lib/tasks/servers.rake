namespace :servers  do

  desc "Starts servers necessary for acceptance"
  task :start => %w{ rails_server:start stubs:start }

  desc "Stops servers necessary for acceptance"
  task :stop do
    exceptions = []
    %w{ rails_server:stop stubs:stop }.each do |task_name|
      begin
        Rake::Task[task_name].invoke
      rescue => exc
        exceptions << exc
      end
    end
    fail exceptions.map { |exc| exc.to_s }.join("\n") unless exceptions.empty?
  end

  desc "Status of servers necessary for acceptance"
  task :status => %w{ rails_server:status stubs:status }

end
