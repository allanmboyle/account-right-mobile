desc "Deletes generated artifacts"
task(:clean => %w{ assets:clean jasmine:clean })

desc "Compile pipeline stage"
task(:compile => "assets:precompile")

desc "Unit & Integration test pipeline stage"
task(:unit => [:jasmine, :coverage])

desc "Commit pipeline phase"
task(:commit => %w{clean compile metrics unit})

desc "Acceptance pipeline stage"
generate_acceptance_task(:acceptance, :cucumber)
