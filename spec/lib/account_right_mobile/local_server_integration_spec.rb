describe AccountRightMobile::LocalServer do
  include_context "server lifecycle utilities"

  class TestRackServer < AccountRightMobile::LocalServer

    def initialize(options)
      super({ name: "test_rack_server" }.merge(options))
    end

    def start_command
      "rackup -p #{@port} #{Rails.root}/spec/resources/test_server_config.ru"
    end

  end

  let(:description) { "Test Rack Server" }
  let(:port) { 4001 }
  let(:pid_file_name) { "test_rack_server.pid" }
  let(:server) { TestRackServer.new(port: port) }

  describe "#start!" do

    after(:each) { force_stop! }

    describe "when the server is not running" do

      it "should start the server via the provided command" do
        server.start!

        wait_until_started!
      end

      it "should create a pid file for the server" do
        server.start!

        AccountRightMobile::Wait.until_true!("test rack server pid created") { pid_file_exists? }
      end

      it "should create a log file capturing the stdout and stderr of the server" do
        server.start!

        AccountRightMobile::Wait.until_true!("test rack server log file created") do
          File.exists?("#{Rails.root}/log/test_rack_server_console.log")
        end
      end

      it "should log that the server started" do
        log.should_receive(:info).with(/started/)

        server.start!
      end

    end

    describe "when the server is already running" do

      before(:each) { server.start! }

      it "should raise an exception indicating the server is already running" do
        lambda { server.start! }.should raise_error(/already running/)
      end

    end

  end

  describe "#stop!" do

    describe "when the server is running" do

      before(:each) { force_start! }

      after(:each) { wait_until_stopped! }

      it "should stop the server" do
        server.stop!

        wait_until_stopped!
      end

      it "should delete the servers pid file" do
        server.stop!

        AccountRightMobile::Wait.until_true!("test rack server pid is deleted") do
          !File.exists?("#{Rails.root}/tmp/pids/test_rack_server.pid")
        end
      end

      it "should log that the server has stopped" do
        log.should_receive(:info).with(/stopped/)

        server.stop!
      end

    end

    describe "when the server is not running" do

      it "should raise an exception indicating the server is not running" do
        lambda { server.stop! }.should raise_error(/not running/)
      end

    end

  end

  describe "#status" do

    describe "when the server is running" do

      before(:each) { force_start! }

      after(:each) { force_stop! }

      it "should return :started" do
        server.status.should eql(:started)
      end

    end

    describe "when the server is not running" do

      it "should return :stopped" do
        server.status.should eql(:stopped)
      end

    end

  end

  describe "#to_s" do

    it "should return a string containing the servers name" do
      server.to_s.should match(/test_rack_server/)
    end

    it "should return a string containing the servers port" do
      server.to_s.should match(/#{port}/)
    end

  end

end
