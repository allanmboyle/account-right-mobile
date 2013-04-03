describe AccountRight::API::RetryingCommandProcessor do

  describe ".execute" do

    let(:access_token) { "some_access_token" }
    let(:refresh_token) { "some_refresh_token" }
    let(:security_tokens) { { access_token: access_token, refresh_token: refresh_token } }
    let(:command) { double(AccountRight::API::QueryCommand, security_tokens: security_tokens) }
    let(:response_body) { "some response body" }

    describe "when the execution of the first API command is successful" do

      before(:each) do
        AccountRight::API::SimpleCommandProcessor.stub!(:execute).with(command).and_return(response_body)
      end

      it "should return the API response" do
        perform_execute.should eql(response_body)
      end

    end

    describe "when the execution of the first API command is unsuccessful" do

      before(:each) do
        AccountRight::API::SimpleCommandProcessor.stub!(:execute).with do |command|
          command.security_tokens[:access_token] == access_token
        end.and_raise(error)
      end

      describe "due to an authorization failure" do

        let(:error) { AccountRight::API::AuthorizationFailure.new(double("HttpResponse", body: "some body")) }
        let(:new_access_token) { "another_access_token" }
        let(:new_refresh_token) { "another_refresh_token" }
        
        before(:each) do
          AccountRight::OAuth.stub!(:re_login).and_return(access_token: new_access_token,
                                                          refresh_token: new_refresh_token)

          AccountRight::API::SimpleCommandProcessor.stub!(:execute).with do |command|
            command.security_tokens[:access_token] == new_access_token
          end.and_return(response_body)
        end

        it "should re-login the user via oAuth" do
          AccountRight::OAuth.should_receive(:re_login).with(refresh_token).and_return(access_token: new_access_token, 
                                                                                       refresh_token: new_refresh_token)
          
          perform_execute
        end
        
        it "should update the commands access security token with the token returned by the re-login request" do
          perform_execute
          
          command.security_tokens[:access_token].should eql(new_access_token)
        end

        it "should update the commands refresh security token with the token returned by the re-login request" do
          perform_execute
          
          command.security_tokens[:refresh_token].should eql(new_refresh_token)
        end

        it "should re-execute the command with the updated security tokens" do
          AccountRight::API::SimpleCommandProcessor.should_receive(:execute).with do |command|
            command.security_tokens[:access_token] == new_access_token &&
                command.security_tokens[:refresh_token] == new_refresh_token
          end.and_return(response_body)

          perform_execute
        end

        describe "and execution of the new command succeeds" do

          it "should return the execution result for the new command" do
            perform_execute.should eql(response_body)
          end

        end

        describe "and execution of the new command fails" do

          let(:new_error) do
            AccountRight::API::Error.new(double("HttpResponse", body: "another error body", code: 400))
          end

          before(:each) do
            AccountRight::API::SimpleCommandProcessor.stub!(:execute).with do |command|
              command.security_tokens[:access_token] == new_access_token
            end.and_raise(new_error)
          end

          it "should propagate the exception raised by executing the new command" do
            lambda { perform_execute }.should raise_error(new_error)
          end

        end

      end

      describe "due to another type of error" do

        let(:error) { AccountRight::API::Error.new(double("HttpResponse", body: "some error body", code: 400)) }

        it "should propagate the exception raised by executing the command" do
           lambda { perform_execute }.should raise_error(error)
        end

      end

    end

    def perform_execute
      AccountRight::API::RetryingCommandProcessor.execute(command)
    end

  end

end
