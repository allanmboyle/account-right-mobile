describe AccountRightMobile::Services::RailsServer do
  include_context "managed http server integration utilities"

  let(:pid_file_name) { "server.pid" }

  let(:server) { AccountRightMobile::Services::RailsServer.new(environment: "test", port: 4003) }

  it_should_behave_like "a managed http server"

  describe "#stop!" do

    before(:each) do
      force_start!
    end

    after(:each) { wait_until_stopped! } # Ensure server has completely stopped

    it "should delete the Rails default server pid file" do
      server.stop!

      ::Wait.until_false!("#{server.name} pid is deleted") do
        File.exists?("#{Rails.root}/tmp/pids/server.pid")
      end
    end

  end

end
