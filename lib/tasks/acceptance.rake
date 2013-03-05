module Acceptance
  CUCUMBER_TARGETS = [:ok, :wip, :rerun, :all]
end

namespace :acceptance do

  Acceptance::CUCUMBER_TARGETS.each do |cucumber_task|
    desc "cucumber:#{cucumber_task} with test environment configured"
    task cucumber_task => "cucumber:#{cucumber_task}"
  end

  namespace :with_servers do

    Acceptance::CUCUMBER_TARGETS.each do |cucumber_task|
      desc "acceptance:#{cucumber_task} with server lifecycle managed"
      task cucumber_task => %w{ servers:start } do
        begin
          Rake::Task["acceptance:#{cucumber_task}"].invoke
        ensure
          Rake::Task["servers:stop"].invoke
        end
      end

    end

  end

end
