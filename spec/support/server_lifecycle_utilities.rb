shared_context "server lifecycle utilities" do

  let(:log) { double("Log").as_null_object }

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
    AccountRightMobile::Wait.until!("#{description} starts") do
      Net::HTTP.get_response("localhost", "/", port)
    end
  end

  def wait_until_stopped!
    AccountRightMobile::Wait.until!("#{description} stops") do
      begin
        Net::HTTP.get_response("localhost", "/", port)
        raise "#{description} still running"
      rescue => exc
        # Intentionally blank
      end
    end
  end

end
