describe AccountRight::ApiError do

  let(:response) { double("HttpResponse", code: 500, body: "some response body") }

  let(:error) { AccountRight::ApiError.new(response) }

  it "should be an standard Ruby exception" do
    error.should be_an(Exception)
  end

  describe "#message" do

    it "should be the response body provided to the error" do
      error.message.should eql("some response body")
    end

  end

  describe "#response_code" do

    it "should return the response code provided to the error" do
      error.response_code.should eql(500)
    end

  end

end
