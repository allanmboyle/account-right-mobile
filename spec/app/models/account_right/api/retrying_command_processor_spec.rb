describe AccountRight::API::RetryingCommandProcessor do

  describe ".execute" do

    let(:access_token) { "some_access_token" }
    let(:refresh_token) { "some_refresh_token" }
    let(:client_application_state) do
      AccountRightMobile::ClientApplicationStateFactory.create(access_token: access_token,refresh_token: refresh_token)
    end
    let(:command) { double(AccountRight::API::QueryCommand, client_application_state: client_application_state) }
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
          command.client_application_state[:access_token] == access_token
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
            command.client_application_state[:access_token] == new_access_token
          end.and_return(response_body)
        end

        it "should re-login the user via OAuth" do
          AccountRight::OAuth.should_receive(:re_login).with(refresh_token).and_return(access_token: new_access_token, 
                                                                                       refresh_token: new_refresh_token)
          
          perform_execute
        end
        
        it "should save the commands client application state with the access token in the re-login response" do
          perform_execute
          
          client_application_state.last_saved_state.should include(access_token: new_access_token)
        end

        it "should save the commands client application state with the refresh token in the re-login response" do
          perform_execute

          client_application_state.last_saved_state.should include(refresh_token: new_refresh_token)
        end

        it "should re-execute the command with the updated client application state" do
          AccountRight::API::SimpleCommandProcessor.should_receive(:execute).with do |command|
            command.client_application_state[:access_token] == new_access_token &&
                command.client_application_state[:refresh_token] == new_refresh_token
          end.and_return(response_body)

          perform_execute
        end

        describe "and execution of the new command succeeds" do

          it "should return the execution result for the new command" do
            perform_execute.should eql(response_body)
          end

        end

        describe "and execution of the new command fails" do

          let(:new_error) { AccountRight::API::ErrorFactory.create(400) }

          before(:each) do
            AccountRight::API::SimpleCommandProcessor.stub!(:execute).with do |command|
              command.client_application_state[:access_token] == new_access_token
            end.and_raise(new_error)
          end

          it "should propagate the exception raised by executing the new command" do
            lambda { perform_execute }.should raise_error(new_error)
          end

        end

      end

      describe "due to another type of error" do

        let(:error) { AccountRight::API::ErrorFactory.create(400) }

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
