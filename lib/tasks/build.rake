namespace(:build) do

  desc "Deletes build artifacts"
  task(:clean => "compile:clean")

  desc "Commit pipeline phase"
  task(:commit => %w{build:clean compile:all metrics:all})

end
