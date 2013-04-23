describe TestableAuthenticationFilters, type: :controller do

  describe "#require_live_login" do

    let(:client_application_state) { double(AccountRightMobile::ClientApplicationState) }

    before(:each) { AccountRightMobile::ClientApplicationState.stub!(:new).and_return(client_application_state) }

    describe "when the client application state indicates the user has logged-in to AccountRight Live" do

      before(:each) { client_application_state.stub!(:logged_in_to_live?).and_return(true) }

      it "should allow the action to be executed as normal" do
        post :action_requiring_live_login, format: :json

        response.body.should eql("Normal body")
      end

    end

    describe "when the client application state indicates the user has not logged-in to AccountRight Live" do

      before(:each) { client_application_state.stub!(:logged_in_to_live?).and_return(false) }

      it "should respond with a status of 401 indicating the request was unauthorised" do
        post :action_requiring_live_login, format: :json

        response.status.should eql(401)
      end

      it "should respond with a body indicating an AccountRight Live login is required" do
        post :action_requiring_live_login, format: :json

        response.body.should eql({ loginRequired: :live_login }.to_json)
      end

    end

  end

  describe "#require_customer_file_login" do

    let(:client_application_state) { double(AccountRightMobile::ClientApplicationState) }

    before(:each) { AccountRightMobile::ClientApplicationState.stub!(:new).and_return(client_application_state) }

    describe "when the client application state indicates the user has logged-in to a Customer File" do

      before(:each) { client_application_state.stub!(:logged_in_to_customer_file?).and_return(true) }

      it "should allow the action to be executed as normal" do
        post :action_requiring_customer_file_login, format: :json

        response.body.should eql("Normal body")
      end

    end

    describe "when the client application state indicates the user has not logged-in to a Customer File" do

      before(:each) { client_application_state.stub!(:logged_in_to_customer_file?).and_return(false) }

      it "should respond with a status of 401 indicating the request was unauthorised" do
        post :action_requiring_customer_file_login, format: :json

        response.status.should eql(401)
      end

      it "should respond with a body indicating a Customer File login is required" do
        post :action_requiring_customer_file_login, format: :json

        response.body.should eql({ loginRequired: :customer_files }.to_json)
      end

    end

  end

end
