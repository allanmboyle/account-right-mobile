def generate_acceptance_task(task_name, cucumber_target)
  task task_name => %w{ rails_server:start oauth_stub_server:start } do
    puts "Executing acceptance tests"
    begin
      Rake::Task[cucumber_target].invoke
    ensure
      %w{ rails_server:stop oauth_stub_server:stop }.each { |task_name| Rake::Task[task_name].invoke }
    end
  end
end

namespace :acceptance do

  desc "Exercises acceptance tests marked as wip"
  generate_acceptance_task(:wip, "cucumber:wip")

end
