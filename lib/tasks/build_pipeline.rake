desc "Deletes generated artifacts"
task(:clean => "assets:clean")

desc "Compile pipeline stage"
task(:compile => "assets:precompile")

desc "Commit pipeline phase"
task(:commit => %w{clean compile metrics})

desc "Acceptance pipeline stage"
task(:acceptance => "cucumber")
