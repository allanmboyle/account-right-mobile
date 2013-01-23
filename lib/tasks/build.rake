namespace(:build) do

  desc "Deletes build artifacts"
  task(:clean => "assets:clean")

  desc "Commit pipeline phase"
  task(:commit => %w{build:clean assets:compile metrics:all})

end
