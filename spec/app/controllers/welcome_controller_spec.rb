describe WelcomeController, type: :controller do

  describe "#index" do

    let(:client_application_state) { double(AccountRightMobile::ClientApplicationState) }
    let(:customer_file_response) { "some customer file response" }

    before(:each) do
      AccountRightMobile::ClientApplicationState.stub!(:new).and_return(client_application_state)
      AccountRight::CustomerFile.stub!(:find).and_return(customer_file_response)
    end

    it "should retrieve the customer file that has previously been established in the application state for the user" do
      AccountRight::CustomerFile.should_receive(:find).with(client_application_state)

      get :index
    end

    describe "when retrieval of the customer file is successful" do

      it "should assign the retrieved customer file to an opened customer file variable" do
        get :index

        assigns(:opened_customer_file).should eql(customer_file_response)
      end

      it "should render the single page application view" do
        get :index

        response.should render_template("index")
      end

    end

    describe "when retrieval of the customer file causes an exception" do

      before(:each) do
        AccountRight::CustomerFile.stub!(:find).and_raise(AccountRight::API::Exception.new("Forced exception"))
      end

      it "should assign an empty JSON hash to the opened customer file variable" do
        get :index

        assigns(:opened_customer_file).should eql("{}")
      end

    end

  end

end
