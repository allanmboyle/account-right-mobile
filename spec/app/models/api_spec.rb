describe AccountRight::API do

  let(:logger) { double("Logger").as_null_object }

  before(:each) { Rails.stub!(:logger).and_return(logger) }

  describe ".invoke" do

    let(:uri) { "some uri" }
    let(:access_token) { "some token" }
    let(:response_body) { "some response body" }
    let(:response) { double("HTTPResponse", :body => response_body) }

    before(:each) { HTTParty.stub!(:get).and_return(response) }

    it "should log the requested URI at info level" do
      logger.should_receive(:info).with(/#{uri}/)

      AccountRight::API.invoke(uri, access_token)
    end

    it "should log the response at info level" do
      logger.should_receive(:info).with(/#{response_body}/)

      AccountRight::API.invoke(uri, access_token)
    end

  end

end
