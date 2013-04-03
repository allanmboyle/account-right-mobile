describe AccountRight::API do

  describe ".invoke" do

    let(:resource_path) { "/some/resource/path" }
    let(:security_tokens) { { some_token: "some_value" } }
    let(:query) { double(AccountRight::API::Query).as_null_object }

    before(:each) { AccountRight::API::SimpleQueryExecutor.stub!(:execute) }

    it "should create an API query for the resource with the provided security tokens" do
      AccountRight::API::Query.should_receive(:new).with(resource_path, security_tokens).and_return(query)

      AccountRight::API.invoke(resource_path, security_tokens)
    end

    it "should return the result of executing the query via the simple query executor" do
      AccountRight::API::Query.stub!(:new).and_return(query)
      AccountRight::API::SimpleQueryExecutor.should_receive(:execute).with(query).and_return("some json result")

      AccountRight::API.invoke(resource_path, security_tokens).should eql("some json result")
    end

  end

end
