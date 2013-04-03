describe AccountRight::API::SimpleQueryExecutor do

  describe ".execute" do

    let(:uri) { "some/resource/uri" }
    let(:headers) { { "header_key" => "header_value" } }
    let(:query) { double(AccountRight::API::Query, uri: uri, headers: headers) }
    let(:response_body) { "some response body" }
    let(:response_code) { 200 }
    let(:response) { double("HttpResponse", body: response_body, code: response_code) }
    let(:logger) { double("Logger").as_null_object }

    before(:each) do
      HTTParty.stub!(:get).and_return(response)

      Rails.stub!(:logger).and_return(logger)
    end

    it "should issue a GET to the API requesting the query's uri" do
      HTTParty.should_receive(:get).with(uri, anything)

      perform_execute
    end

    it "should issue a GET request to the API containing the query's headers" do
      HTTParty.should_receive(:get).with(anything, headers: headers)

      perform_execute
    end

    it "should log the resource requested via the Rails logger" do
      logger.should_receive(:info).with(/#{uri}/)

      perform_execute
    end

    it "should log the headers provided via the Rails logger" do
      logger.should_receive(:info).with(/#{headers}/)

      perform_execute
    end

    it "logs the API response code via the Rails logger" do
      logger.should_receive(:info).with(/#{response_code}/)

      perform_execute
    end

    it "logs the API response body via the Rails logger" do
      logger.should_receive(:info).with(/#{response_body}/)

      perform_execute
    end

    it "should return the API response body" do
      perform_execute.should eql(response_body)
    end

    describe "when a non-200 response is received" do

      let(:response_code) { 400 }

      it "should create an API error containing the response" do
        AccountRight::API::Error.should_receive(:new).with(response)

        lambda { perform_execute }.should raise_error
      end

      it "should raise the API error containing the response" do
        lambda { perform_execute }.should raise_error(AccountRight::API::Error)
      end

    end

  end

  def perform_execute
    AccountRight::API::SimpleQueryExecutor.execute(query)
  end

end
