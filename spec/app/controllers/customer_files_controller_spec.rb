describe CustomerFilesController, type: :controller do

  describe "#index" do

    let(:access_token) { "some_access_token" }

    before(:each) { session[:access_token] = access_token }

    it "should retrieve customer files for the current AccountRight Live user via the API" do
      AccountRight::API.should_receive(:customer_files).with(access_token)

      get_index
    end

    describe "when the API responds with data" do

      before(:each) do
        AccountRight::API.stub!(:customer_files).and_return("some json")
      end

      it "should respond with status of 200" do
        get_index

        response.status.should eql(200)
      end

      it "should return the response from the api" do
        get_index

        response.body.should eql("some json")
      end

    end

    def get_index
      get :index, format: :json
    end

  end

end
