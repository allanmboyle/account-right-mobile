describe AccountRight::API::Exception do

  let(:message) { "some message" }

  let(:exception) { AccountRight::API::Exception.new(message) }

  it "should be a standard Ruby exception" do
    exception.should be_an(::Exception)
  end

  describe "#message" do

    it "should be the response body provided to the error" do
      exception.message.should eql("some message")
    end

  end

end
