describe AccountRightMobile::Services::LocalServer do
  include_context "server lifecycle utilities"

  class TestRackServer < AccountRightMobile::Services::LocalServer

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
  let(:server) { TestRackServer.new(port: port, log: log) }

  describe "#start!" do

    after(:each) { force_stop! }

    describe "when the server is not running" do

      after(:each) { wait_until_started! } # Ensure server has completely started

      it "should start the server via the provided command" do
        server.start!

        wait_until_started!
      end

      it "should create a pid file for the server" do
        server.start!

        ::Wait.until_true!("test rack server pid created") { pid_file_exists? }
      end

      it "should create a log file capturing the stdout and stderr of the server" do
        server.start!

        ::Wait.until_true!("test rack server log file created") do
          File.exists?("#{Rails.root}/log/test_rack_server_console.log")
        end
      end

      it "should log that the server started on the configured port" do
        log.should_receive(:info).with(/started on port #{port}/)

        server.start!
      end

    end

    describe "when the server is already running" do

      before(:each) do
        server.start!
        wait_until_started!
      end

      it "should log that the server is already running on the configured port" do
        log.should_receive(:info).with(/already running on port #{port}/)

        server.start!
      end

    end

  end

  describe "#stop!" do

    describe "when the server is running" do

      before(:each) { force_start! }

      after(:each) { wait_until_stopped! } # Ensure server has completely stopped

      it "should stop the server" do
        server.stop!

        wait_until_stopped!
      end

      it "should delete the servers pid file" do
        server.stop!

        ::Wait.until_false!("test rack server pid is deleted") do
          File.exists?("#{Rails.root}/tmp/pids/test_rack_server.pid")
        end
      end

      it "should log that the server has stopped" do
        log.should_receive(:info).with(/stopped/)

        server.stop!
      end

    end

    describe "when the server is not running" do

      it "should log that the server is not running" do
        log.should_receive(:info).with(/not running/)

        server.stop!
      end

    end

  end

  describe "#status" do

    describe "when the server is running" do

      before(:each) { force_start! }

      after(:each) { force_stop! }

      describe "and the pid file exists" do

        it "should return :started" do
          server.status.should eql(:started)
        end

      end

      describe "and the pid file does not exist" do

        before(:each) { force_pid_file_deletion! }

        after(:each) { restore_pid_file! }

        it "should return :started" do
          server.status.should eql(:started)
        end

      end

    end

    describe "when the server is not running" do

      describe "and the pid file does not exist" do

        it "should return :stopped" do
          server.status.should eql(:stopped)
        end

      end

      describe "and the pid file exists" do

        before(:each) { force_pid_file_creation! }

        after(:each) { force_pid_file_deletion! }

        it "should return :stopped" do
          server.status.should eql(:stopped)
        end

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
