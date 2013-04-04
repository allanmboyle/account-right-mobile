describe LiveUserController, type: :controller do

  let(:_csrf_token) { "some_csrf_token" }

  before(:each) { session[:_csrf_token] = _csrf_token }

  describe "#reset" do

    describe "GET" do

      describe "when a json request is made" do

        it "should respond with a status of 200" do
          get_reset

          response.status.should eql(200)
        end

        describe "and the users session contains data" do

          before(:each) { session[:key] = "value" }

          it "should retain the cross site request forgery token in the users session" do
            get_reset

            session[:_csrf_token].should eql(_csrf_token)
          end

          it "should empty other data in the users session" do
            get_reset

            session[:key].should be_nil
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
          let(:user_tokens) { double(AccountRight::UserTokens).as_null_object }

          before(:each) do
            AccountRight::LiveUser.stub!(:new).and_return(user)
            AccountRight::UserTokens.stub!(:new).and_return(user_tokens)
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

            it "should create user tokens encapsulating tokens in the users session" do
              AccountRight::UserTokens.should_receive(:new).with(session).and_return(user_tokens)

              post_login
            end

            it "should save the login response's access token in the users tokens" do
              user_tokens.should_receive(:save).with(hash_including(access_token: access_token))

              post_login
            end

            it "should save the login response's refresh token in the users tokens" do
              user_tokens.should_receive(:save).with(hash_including(refresh_token: refresh_token))

              post_login
            end

            it "should respond with an empty json body" do
              post_login

              response.body.should eql({}.to_json)
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
