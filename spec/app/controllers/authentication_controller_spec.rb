describe AuthenticationController, type: :controller do

  describe "#live_login" do

    describe "POST" do

      describe "when a json response is requested" do

        it "should return an empty object" do
          post :live_login, format: :json

          response.body.should eql({}.to_json)
        end

      end

    end

  end

end
