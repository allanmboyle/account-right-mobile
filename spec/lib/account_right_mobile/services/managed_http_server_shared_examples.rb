shared_examples_for "a managed http server" do
  include_context "managed http server integration utilities"

  it "should be a HttpServerManager::Server" do
    server.should be_an(HttpServerManager::Server)
  end

  describe "#start!" do

    after(:each) { force_stop! }

    it "should start the server via the provided command" do
      server.start!

      wait_until_started!
    end

  end

end
