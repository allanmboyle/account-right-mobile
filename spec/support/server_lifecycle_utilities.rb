shared_context "server lifecycle utilities" do

  let(:log) { double("Log").as_null_object }
  let(:pid_file_path) { "#{Rails.root}/tmp/pids/#{pid_file_name}"}

  before(:each) { server.log = log }

  def force_start!
    server.start!
    wait_until_started!
  end

  def force_stop!
    server.stop!
    wait_until_stopped!
  end

  def wait_until_started!
    AccountRightMobile::Wait.until_true!("#{description} starts") do
      !!Net::HTTP.get_response("localhost", "/", port) && pid_file_exists?
    end
  end

  def wait_until_stopped!
    AccountRightMobile::Wait.until_true!("#{description} stops") do
      begin
        Net::HTTP.get_response("localhost", "/", port)
        false
      rescue
        !pid_file_exists?
      end
    end
  end

  def pid_file_exists?
    File.exists?(pid_file_path)
  end

end
