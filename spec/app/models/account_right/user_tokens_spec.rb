describe AccountRight::UserTokens do

  let(:session) { double("HttpSession").as_null_object }
  let(:user_tokens) { AccountRight::UserTokens.new(session) }

  before(:each) { session.stub!(:[]).and_return(nil) }

  describe "#[]" do

    describe "when user tokens have been established in the users session" do

      before(:each) do
        session.stub!(:[]).with(:access_token).and_return("some access token")
        session.stub!(:[]).with(:refresh_token).and_return("some refresh token")
        session.stub!(:[]).with(:cf_token).and_return("some customer file token")
      end

      it "should expose the access token in the users session" do
        user_tokens[:access_token].should eql("some access token")
      end

      it "should expose the refresh token in the users session" do
        user_tokens[:refresh_token].should eql("some refresh token")
      end

      it "should expose the customer file token in the users session" do
        user_tokens[:cf_token].should eql("some customer file token")
      end

      describe "and the tokens value has been overwritten in the user tokens" do

        before(:each) { user_tokens[:access_token] = "some other access token" }

        it "should return the override value" do
          user_tokens[:access_token].should eql("some other access token")
        end

      end

    end

    describe "when the tokens value has been established directly in the tokens" do

      before(:each) { user_tokens[:access_token] = "some value" }

      it "should return the established value" do
        user_tokens[:access_token].should eql("some value")
      end

    end

    describe "when the tokens value has not been established" do

      it "should return nil" do
        user_tokens[:access_token].should be_nil
      end

    end

  end


  describe "#save" do

    describe "when provided arguments" do

      let(:arguments) do
        (1..3).reduce({}) do |result, i|
          result["key#{i}".to_sym] = "value#{i}"
          result
        end
      end

      it "should update the session with the tokens provided as arguments" do
        session.should_receive(:update).with(hash_including(arguments))

        user_tokens.save(arguments)
      end

      it "should retain the arguments" do
        user_tokens.save(arguments)

        user_tokens[:key1].should eql("value1")
      end

    end

    describe "when provided no arguments" do

      describe "and tokens have been added" do

        let(:added_tokens) do
          (1..3).reduce({}) do |result, i|
            result["key#{i}".to_sym] = "value#{i}"
            result
          end
        end

        before(:each) do
          added_tokens.each { |key, value| user_tokens[key] = value }
        end

        it "should update the session with the added tokens" do
          session.should_receive(:update).with(hash_including(added_tokens))

          user_tokens.save
        end

      end

    end

  end

end
