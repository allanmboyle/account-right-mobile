describe AccountRight::API::SimpleCommandProcessor do

  describe ".execute" do

    let(:response_body) { "some response body" }
    let(:response_code) { 200 }
    let(:response) { double("HttpResponse", body: response_body, code: response_code) }
    let(:command_description) { "some command description" }
    let(:command) { double("AccountRight::API::Command", submit: response, to_s: command_description) }
    let(:logger) { double("Logger").as_null_object }

    before(:each) { Rails.stub!(:logger).and_return(logger) }

    it "should submit the command" do
      command.should_receive(:submit)

      perform_execute
    end

    it "should log the command submitted via the Rails logger" do
      logger.should_receive(:info).with(/#{command_description}/)

      perform_execute
    end

    it "logs the command submission response code via the Rails logger" do
      logger.should_receive(:info).with(/#{response_code}/)

      perform_execute
    end

    it "logs the command response body via the Rails logger" do
      logger.should_receive(:info).with(/#{response_body}/)

      perform_execute
    end

    describe "when a 200 response is received" do

      it "should return the API response body" do
        perform_execute.should eql(response_body)
      end

    end

    describe "when a 401 response is received" do

      let(:response_code) { 401 }

      it "should create an authorization failure containing the response" do
        AccountRight::API::AuthorizationFailure.should_receive(:new).with(response)

        lambda { perform_execute }.should raise_error
      end

      it "should raise the created failure" do
        lambda { perform_execute }.should raise_error(AccountRight::API::AuthorizationFailure)
      end

    end

    describe "when the response has another response code" do

      let(:response_code) { 500 }

      it "should create an error containing the response" do
        AccountRight::API::Error.should_receive(:new).with(response)

        lambda { perform_execute }.should raise_error
      end

      it "should raise the created error" do
        lambda { perform_execute }.should raise_error(AccountRight::API::Error)
      end

    end

  end

  def perform_execute
    AccountRight::API::SimpleCommandProcessor.execute(command)
  end

end
