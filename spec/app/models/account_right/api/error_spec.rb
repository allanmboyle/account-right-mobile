describe AccountRight::API::Error do

  let(:response) { double("HttpResponse", code: 500, body: "some response body") }

  let(:error) { AccountRight::API::Error.new(response) }

  it "should be an standard Ruby exception" do
    error.should be_an(Exception)
  end

  describe "#message" do

    it "should contain the code of the response provided to the error" do
      error.message.should include("500")
    end

    it "should contain the body of the response provided to the error" do
      error.message.should include("some response body")
    end

  end

  describe "#response_code" do

    it "should return the response code provided to the error" do
      error.response_code.should eql(500)
    end

  end

  describe "#to_s" do

    it "should return the message" do
      error.to_s.should eql(error.message)
    end

  end

end
