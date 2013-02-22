def generate_acceptance_task(task_name, cucumber_target)
  task task_name => "servers:start" do
    puts "Executing acceptance tests"
    begin
      Rake::Task[cucumber_target].invoke
    ensure
      Rake::Task["servers:stop"].invoke
    end
  end
end

namespace :acceptance do

  desc "Exercises acceptance tests marked as wip"
  generate_acceptance_task(:wip, "cucumber:wip")

end
