shared_examples_for "an action that only accepts json" do

  describe "when a non-json response is requested" do

    it "should respond with a status indicating the requested response type is not acceptable" do
      request_action format: :html

      response.status.should eql(406)
    end

  end

end
