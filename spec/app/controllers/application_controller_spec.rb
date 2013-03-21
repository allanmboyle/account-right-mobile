describe TestableApplicationController, type: :controller do

  describe "#respond_to_json" do

    describe "when a json response is requested" do

      it "should respond with the JSON content" do
        post :some_action, format: :json

        response.body.should eql("Some JSON")
      end

    end

    describe "when a non-JSON request is issued" do

      it "should respond with a status indicating the requested response type is not acceptable" do
        post :some_action, format: :html

        response.status.should eql(406)
      end

    end

  end

end
