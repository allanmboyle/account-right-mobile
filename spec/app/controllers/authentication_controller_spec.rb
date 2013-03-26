describe AuthenticationController, type: :controller do

  let(:_csrf_token) { "some_csrf_token" }

  before(:each) { session[:_csrf_token] = _csrf_token }

  shared_examples_for "a login action that has standard responses to failure scenarios" do

    describe "when the user login is unsuccessful" do

      before(:each) do
        user.stub!(:login).and_raise(AccountRight::AuthenticationFailure)
      end

      it "should respond with a status of 401" do
        post_login

        response.status.should eql(401)
      end

    end

    describe "when the user login causes an error" do

      before(:each) do
        user.stub!(:login).and_raise(AccountRight::AuthenticationError)
      end

      it "should respond with a status of 500" do
        post_login

        response.status.should eql(500)
      end

    end

  end

  describe "#live_login" do

    describe "POST" do

      describe "and credentials are provided" do

        let(:email_address) { "some@email.address" }
        let(:password) { "some_password" }
        let(:credentials) { { emailAddress: email_address, password: password } }
        let(:user) { double(AccountRight::LiveUser).as_null_object }

        before(:each) { AccountRight::LiveUser.stub!(:new).and_return(user) }

        it "should create a live user with the credentials" do
          AccountRight::LiveUser.should_receive(:new).with(username: email_address, password: password)
                                                     .and_return(user)

          post_login
        end

        describe "when the user login is successful" do

          before(:each) do
            user.stub!(:login).and_return(access_token: "someAccessToken", refresh_token: "someRefreshToken")
          end

          it "should respond with status of 200" do
            post_login

            response.status.should eql(200)
          end

          it "should reset the users session for security reasons" do
            controller.should_receive(:reset_session)

            post_login
          end

          it "should establish the access token in the users session" do
            post_login

            session[:access_token].should eql("someAccessToken")
          end

          it "should retain the cross site request forgery token in the users session" do
            post_login

            session[:_csrf_token].should eql(_csrf_token)
          end

          it "should respond with an empty json body" do
            post_login

            response.body.should eql({}.to_json)
          end

        end

        it_should_behave_like "a login action that has standard responses to failure scenarios"

        def post_login
          post :live_login, credentials.merge(format: :json)
        end

      end

      it_should_behave_like "an action that only accepts json"

      def request_action(options)
        post :customer_file_login, options
      end

    end

  end

  describe "#customer_file_login" do

    describe "POST" do

      describe "and credentials are provided" do

        let(:username) { "some_username" }
        let(:password) { "some_password" }
        let(:credentials) { { username: username, password: password } }
        let(:file_id) { "9876543210" }

        let(:access_token) { "some_access_token" }
        let(:cf_token) { "some_customer_file_token" }

        let(:user) { double(AccountRight::CustomerFileUser, cf_token: cf_token).as_null_object }

        before(:each) do
          session[:access_token] = access_token

          AccountRight::CustomerFileUser.stub!(:new).and_return(user)
        end

        it "should create a customer file user with the credentials" do
          AccountRight::CustomerFileUser.should_receive(:new).with(username: username, password: password)
                                                             .and_return(user)

          post_login
        end

        describe "when the user login is successful" do

          before(:each) do
            user.stub!(:login).with(file_id, access_token)
          end

          it "should respond with status of 200" do
            post_login

            response.status.should eql(200)
          end

          it "should reset the users session for security reasons" do
            controller.should_receive(:reset_session)

            post_login
          end

          it "should establish the users company file token in the users session" do
            post_login

            session[:cf_token].should eql(cf_token)
          end

          it "should retain the cross site request forgery token in the users session" do
            post_login

            session[:_csrf_token].should eql(_csrf_token)
          end

          it "should retain the access token in the users session" do
            post_login

            session[:access_token].should eql(access_token)
          end

          it "should respond with an empty json body" do
            post_login

            response.body.should eql({}.to_json)
          end

        end

        it_should_behave_like "a login action that has standard responses to failure scenarios"

        def post_login
          request_action credentials.merge(fileId: file_id, format: :json)
        end

      end

      it_should_behave_like "an action that only accepts json"

      def request_action(options)
        post :customer_file_login, options
      end

    end

  end

end
