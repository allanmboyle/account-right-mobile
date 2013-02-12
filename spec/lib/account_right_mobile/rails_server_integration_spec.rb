describe AccountRightMobile::RailsServer do
  include_context "server lifecycle utilities"

  let(:description) { "Rails Test Server" }
  let(:port) { 4003 }
  let(:server) { AccountRightMobile::RailsServer.new(environment: "test", port: port) }

  it_should_behave_like "a local server"

  describe "#stop!" do

    before(:each) { force_start! }

    it "should delete the Rails default server pid file" do
      server.stop!

      AccountRightMobile::Wait.until_true!("#{description} pid is deleted") do
        !File.exists?("#{Rails.root}/tmp/pids/server.pid")
      end
    end

  end

end
