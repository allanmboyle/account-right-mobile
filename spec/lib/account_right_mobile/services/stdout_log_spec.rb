describe AccountRightMobile::Services::StdOutLog do

  let(:log) { AccountRightMobile::Services::StdOutLog.new }

  describe "#info" do

    it "should write the message to stdout" do
      message = "Some message"
      log.should_receive(:puts).with(message)

      log.info message
    end

  end

end
