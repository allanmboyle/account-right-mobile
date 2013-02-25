desc "Exercises Jasmine specifications"
task(:jasmine => %w{ jasmine:spec })

namespace(:jasmine) do

  SPEC_COFFEESCRIPTS_DIR = Rails.root.join("spec", "javascripts")
  SPEC_COMPILED_JAVASCRIPTS_DIR = Rails.root.join("tmp", "spec", "javascripts")

  directory SPEC_COMPILED_JAVASCRIPTS_DIR.to_s

  desc "Deletes generated Jasmine artifacts"
  task(:clean) { rm_rf(SPEC_COMPILED_JAVASCRIPTS_DIR) }

  task(:compile => [SPEC_COMPILED_JAVASCRIPTS_DIR.to_s, "node:required", "npm:install"]) do
    AccountRightMobile::Build::CoffeeScript.compile(src_dir: SPEC_COFFEESCRIPTS_DIR,
                                                    dest_dir: SPEC_COMPILED_JAVASCRIPTS_DIR)
  end

  desc "Exercises Jasmine specifications"
  task :spec => "jasmine:spec:headless"

  namespace :spec do

    def generate_jasmine_spec_task(task_name, node_target)
      desc "Exercises Jasmine specifications via node target #{node_target}"
      task(task_name => %w{ jasmine:compile }) do
        output = execute_with_logging "node #{AccountRightMobile::Build::Npm.root.join("grunt", "bin", "grunt")} -v #{node_target}"
        results_match = output.match(/\d* specs, (\d) failure/) || [nil, 0]
        fail "Jasmine specs failed" if results_match[1].to_i > 0
      end
    end

    generate_jasmine_spec_task(:headless, :jasmine)

    generate_jasmine_spec_task(:browser, "jasmine-server")

  end

end
