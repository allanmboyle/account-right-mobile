describe CustomerFileController, type: :controller do
  
  let(:csrf_token) { "some_csrf_token" }
  let(:access_token) { "some_access_token" }
  let(:refresh_token) { "some_refresh_token" }

  before(:each) do
    session[:_csrf_token] = csrf_token
    session[:access_token] = access_token
    session[:refresh_token] = refresh_token
    session[:key] = "value"
  end

  describe "#index" do
    
    describe "GET" do
      
      describe "when a json request is made" do

        before(:each){ AccountRight::API.stub!(:invoke) }

        it "should invoke the API with the access token in the users session" do
          AccountRight::API.should_receive(:invoke).with("accountright", access_token: access_token)

          get_index
        end

        describe "when the API successfully responds" do

          let(:api_response) { { key: "value" }.to_json }

          before(:each) { AccountRight::API.stub!(:invoke).and_return(api_response) }

          it "should respond with a status of 200" do
            get_index

            response.status.should eql(200)
          end

          it "should return the response from the API" do
            get_index

            response.body.should eql(api_response)
          end

        end

        it "should retain the cross site request forgery token in the users session" do
          get_index

          session[:_csrf_token].should eql(csrf_token)
        end

        it "should retain the access token in the users session" do
          get_index

          session[:access_token].should eql(access_token)
        end

        it "should retain the refresh token in the users session" do
          get_index

          session[:refresh_token].should eql(refresh_token)
        end

        it "should empty other data in the users session" do
          get_index

          session[:key].should be_nil
        end

        def get_index
          request_action format: :json
        end

      end
      
      it_should_behave_like "an action that only accepts json"

      def request_action(options)
        get :index, options
      end

    end
    
  end

  describe "#login" do

    describe "POST" do

      describe "when a json request is made" do

        describe "and credentials are provided" do

          let(:username) { "some_username" }
          let(:password) { "some_password" }
          let(:credentials) { { username: username, password: password } }
          let(:file_id) { "9876543210" }
          let(:cf_token) { "some_customer_file_token" }
          let(:user) { double(AccountRight::CustomerFileUser, cf_token: cf_token).as_null_object }

          before(:each) { AccountRight::CustomerFileUser.stub!(:new).and_return(user) }

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

            it "should establish the users company file token in the users session" do
              post_login

              session[:cf_token].should eql(cf_token)
            end

            it "should retain the cross site request forgery token in the users session" do
              post_login

              session[:_csrf_token].should eql(csrf_token)
            end

            it "should retain the access token in the users session" do
              post_login

              session[:access_token].should eql(access_token)
            end

            it "should retain the refresh token in the users session" do
              post_login

              session[:refresh_token].should eql(refresh_token)
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

      end

      it_should_behave_like "an action that only accepts json"

      def request_action(options)
        post :login, options
      end

    end

  end

end