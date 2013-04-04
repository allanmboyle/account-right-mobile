describe AccountRight::API do

  describe ".invoke" do

    let(:resource_path) { "/some/resource/path" }
    let(:user_tokens) { double(AccountRight::UserTokens) }
    let(:command) { double(AccountRight::API::QueryCommand).as_null_object }

    before(:each) { AccountRight::API::RetryingCommandProcessor.stub!(:execute) }

    it "should create a command for the resource with the provided user tokens" do
      AccountRight::API::QueryCommand.should_receive(:new).with(resource_path, user_tokens).and_return(command)

      AccountRight::API.invoke(resource_path, user_tokens)
    end

    it "should return the result of executing the command via the retrying query executor" do
      AccountRight::API::QueryCommand.stub!(:new).and_return(command)
      AccountRight::API::RetryingCommandProcessor.should_receive(:execute).with(command).and_return("some json result")

      AccountRight::API.invoke(resource_path, user_tokens).should eql("some json result")
    end

  end

end
