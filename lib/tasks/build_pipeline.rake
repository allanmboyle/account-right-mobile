desc "Deletes generated artifacts"
task(:clean => %w{ assets:clean jasmine:clean coverage:clean })

desc "Compile pipeline stage"
task(:compile => "assets:precompile")

desc "Unit & Integration test pipeline stage"
task(:unit => [:jasmine, :coverage])

desc "Commit pipeline phase"
task(:commit => %w{clean compile metrics unit})

desc "Acceptance pipeline stage"
task(:acceptance => "acceptance:with_servers:ok")
