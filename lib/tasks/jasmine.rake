desc "Exercises Jasmine specifications"
task(:jasmine => %w{ jasmine:compile jasmine:run })

namespace(:jasmine) do

  SPEC_COFFEESCRIPTS_DIR = Rails.root.join("spec", "javascripts")
  SPEC_COMPILED_JAVASCRIPTS_DIR = Rails.root.join("tmp", "spec", "javascripts")

  directory SPEC_COMPILED_JAVASCRIPTS_DIR.to_s

  desc "Deletes generated Jasmine artifacts"
  task(:clean) { rm_rf(SPEC_COMPILED_JAVASCRIPTS_DIR) }

  task(:compile => [SPEC_COMPILED_JAVASCRIPTS_DIR.to_s, "node:required", "npm:install"]) do
    AccountRightMobile::CoffeeScript.compile(src_dir: SPEC_COFFEESCRIPTS_DIR,
                                             dest_dir: SPEC_COMPILED_JAVASCRIPTS_DIR)
  end

  task(:run => %w{ assets:precompile jasmine:compile }) do
    execute_with_logging "node #{AccountRightMobile::Npm.root.join("grunt", "bin", "grunt")} -v jasmine"
  end

end
