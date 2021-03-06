describe LiveUserController, type: :controller do

  let(:csrf_token) { "some_csrf_token" }

  before(:each) { session[:_csrf_token] = csrf_token }

  describe "#reset" do

    describe "GET" do

      describe "when a json request is made" do

        it "should respond with a status of 200" do
          get_reset

          response.status.should eql(200)
        end

        it "should respond with the default json response" do
          controller.stub!(:default_json_response).and_return("some json response")

          get_reset

          response.body.should eql("some json response")
        end

        describe "and the users session contains data" do

          before(:each) { session[:key] = "value" }

          describe "and contains a cross-site request forgery token" do

            it "should retain the token in the users session" do
              get_reset

              session[:_csrf_token].should eql(csrf_token)
            end

          end

          it "should empty other data in the users session" do
            get_reset

            session[:key].should be_nil
          end

        end

        describe "and the users session does not contain a cross-site request forgery token" do

          let(:csrf_token) { nil }

          it "should establish a new token" do
            get_reset

            session[:_csrf_token].should_not be_nil
          end

        end

        def get_reset
          request_action format: :json
        end

      end

      it_should_behave_like "an action that only accepts json"

      def request_action(options)
        post :reset, options
      end

    end

  end

  describe "#login" do

    describe "POST" do

      describe "when a json request is made" do

        describe "and credentials are provided" do

          let(:email_address) { "some@email.address" }
          let(:password) { "some_password" }
          let(:credentials) { { emailAddress: email_address, password: password } }
          let(:user) { double(AccountRight::LiveUser).as_null_object }
          let(:client_application_state) { double(AccountRightMobile::ClientApplicationState).as_null_object }

          before(:each) do
            AccountRight::LiveUser.stub!(:new).and_return(user)
            AccountRightMobile::ClientApplicationState.stub!(:new).and_return(client_application_state)
          end

          it "should create a live user with the credentials" do
            AccountRight::LiveUser.should_receive(:new).with(username: email_address, password: password)
                                                       .and_return(user)

            post_login
          end

          describe "when the user login is successful" do

            let(:access_token) { "someAccessToken" }
            let(:refresh_token) { "someRefreshToken" }

            before(:each) { user.stub!(:login).and_return(access_token: access_token, refresh_token: refresh_token) }

            it "should respond with status of 200" do
              post_login

              response.status.should eql(200)
            end

            it "should create client application state encapsulating data in the users session" do
              AccountRightMobile::ClientApplicationState.should_receive(:new).with(session)
                                                                             .and_return(client_application_state)

              post_login
            end

            it "should save the login response's access token in the client application state" do
              client_application_state.should_receive(:save).with(hash_including(access_token: access_token))

              post_login
            end

            it "should save the login response's refresh token in the client application state" do
              client_application_state.should_receive(:save).with(hash_including(refresh_token: refresh_token))

              post_login
            end

            it "should respond with the default json response" do
              controller.stub!(:default_json_response).and_return("some json response")

              post_login

              response.body.should eql("some json response")
            end

          end

          it_should_behave_like "a login action that has standard responses to failure scenarios"

          def post_login
            request_action credentials.merge(format: :json)
          end

        end

      end

      it_should_behave_like "an action that only accepts json"

      def request_action(options)
        post :login, options
      end

    end

  end

end
