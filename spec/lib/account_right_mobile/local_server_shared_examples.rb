shared_examples_for "a local server" do
  include_context "server lifecycle utilities"

  it "should be an AccountRightMobile::LocalServer" do
    server.should be_an(AccountRightMobile::LocalServer)
  end

  describe "#start!" do

    after(:each) { force_stop! }

    it "should start the server via the provided command" do
      server.start!

      wait_until_started!
    end

  end

end
