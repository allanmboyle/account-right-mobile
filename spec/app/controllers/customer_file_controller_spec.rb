describe CustomerFileController, type: :controller do
  
  let(:csrf_token) { "some_csrf_token" }
  let(:access_token) { "some_access_token" }
  let(:refresh_token) { "some_refresh_token" }
  let(:client_application_state) { double(AccountRightMobile::ClientApplicationState) }

  before(:each) do
    session[:_csrf_token] = csrf_token
    session[:access_token] = access_token
    session[:refresh_token] = refresh_token
    session[:key] = "value"

    AccountRightMobile::ClientApplicationState.stub!(:new).and_return(client_application_state)

    controller.stub!(:require_live_login)
  end

  describe "#index" do
    
    describe "GET" do
      
      describe "when a json request is made" do

        before(:each) { AccountRight::CustomerFile.stub!(:all) }

        it "should require the user to be logged-in to AccountRight Live" do
          controller.should_receive(:require_live_login)

          get_index
        end

        it "should find all customer files accessible to the user via the model" do
          mandatory_state = hash_including(access_token: access_token, refresh_token: refresh_token)
          AccountRightMobile::ClientApplicationState.should_receive(:new).with(mandatory_state)
                                                                         .and_return(client_application_state)
          AccountRight::CustomerFile.should_receive(:all).with(client_application_state)

          get_index
        end

        describe "when the model successfully responds" do

          let(:model_response) { { key: "value" }.to_json }

          before(:each) { AccountRight::CustomerFile.stub!(:all).and_return(model_response) }

          it "should respond with a status of 200" do
            get_index

            response.status.should eql(200)
          end

          it "should return the response from the model" do
            get_index

            response.body.should eql(model_response)
          end

        end

        describe "and the users session contains a cross-site request forgery token" do

          it "should retain the token" do
            get_index

            session[:_csrf_token].should eql(csrf_token)
          end

        end

        describe "and the users session does not contain a cross-site request forgery token" do

          let(:_csrf_token) { nil }

          it "should establish a new token" do
            get_index

            session[:_csrf_token].should_not be_nil
          end

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
          let(:customer_file_id) { "9876543210" }
          let(:customer_file) { double(AccountRight::CustomerFile) }
          let(:cf_token) { "some_customer_file_token" }
          let(:user) { double(AccountRight::CustomerFileUser, cf_token: cf_token).as_null_object }

          before(:each) do
            AccountRight::CustomerFile.stub!(:new).and_return(customer_file)
            AccountRight::CustomerFileUser.stub!(:new).and_return(user)
            client_application_state.stub!(:save)
          end

          it "should require the user to be logged-in to AccountRight Live" do
            controller.should_receive(:require_live_login)

            post_login
          end

          it "should create a customer file with the provided customer file id" do
            AccountRight::CustomerFile.should_receive(:new).with(id: customer_file_id).and_return(customer_file)

            post_login
          end

          it "should create a customer file user with the customer file and credentials" do
            AccountRight::CustomerFileUser.should_receive(:new)
                                          .with(customer_file: customer_file, username: username, password: password)
                                          .and_return(user)

            post_login
          end

          describe "when the user login is successful" do

            before(:each) do
              user.stub!(:login).with(client_application_state)
            end

            it "should respond with status of 200" do
              post_login

              response.status.should eql(200)
            end

            it "should retain the cross-site request forgery token in the users session" do
              post_login

              session[:_csrf_token].should eql(csrf_token)
            end

            it "should create client application state encapsulating data in the users session" do
              AccountRightMobile::ClientApplicationState.should_receive(:new).with(session)
                                                                             .and_return(client_application_state)

              post_login
            end

            it "should save any changes to the client application state" do
              client_application_state.should_receive(:save).with(no_args)

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
            request_action credentials.merge(fileId: customer_file_id, format: :json)
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
