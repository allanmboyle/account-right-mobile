describe AccountRight::API::AuthorizationFailure do

  let(:response) { double("HttpResponse", code: 500, body: "some response body") }

  let(:authorization_failure) { AccountRight::API::AuthorizationFailure.new(response) }

  it "should be an API exception" do
    authorization_failure.should be_an(AccountRight::API::Exception)
  end

  describe "#message" do

    it "should be the response body provided to the error" do
      authorization_failure.message.should eql("some response body")
    end

  end

end
