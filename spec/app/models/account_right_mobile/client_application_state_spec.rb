describe AccountRightMobile::ClientApplicationState do

  let(:session) { double("HttpSession").as_null_object }
  let(:client_application_state) { AccountRightMobile::ClientApplicationState.new(session) }

  before(:each) { session.stub!(:[]).and_return(nil) }

  describe "#[]" do

    describe "when state has been established in the users session" do

      before(:each) do
        session.stub!(:[]).with(:access_token).and_return("some access token")
        session.stub!(:[]).with(:refresh_token).and_return("some refresh token")
        session.stub!(:[]).with(:cf_token).and_return("some customer file token")
        session.stub!(:[]).with(:cf_id).and_return("some customer file id")
      end

      it "should expose the access token in the users session" do
        client_application_state[:access_token].should eql("some access token")
      end

      it "should expose the refresh token in the users session" do
        client_application_state[:refresh_token].should eql("some refresh token")
      end

      it "should expose the customer file token in the users session" do
        client_application_state[:cf_token].should eql("some customer file token")
      end

      it "should expose the customer file id in the users session" do
        client_application_state[:cf_id].should eql("some customer file id")
      end

      describe "and the value has been overwritten in the client application state" do

        before(:each) { client_application_state[:access_token] = "some other access token" }

        it "should return the override value" do
          client_application_state[:access_token].should eql("some other access token")
        end

      end

    end

    describe "when the value has been established directly in the client application state" do

      before(:each) { client_application_state[:access_token] = "some value" }

      it "should return the established value" do
        client_application_state[:access_token].should eql("some value")
      end

    end

    describe "when the value has not been established" do

      it "should return nil" do
        client_application_state[:access_token].should be_nil
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

      it "should update the session with the state provided as arguments" do
        session.should_receive(:update).with(hash_including(arguments))

        client_application_state.save(arguments)
      end

      it "should retain the arguments" do
        client_application_state.save(arguments)

        client_application_state[:key1].should eql("value1")
      end

    end

    describe "when provided no arguments" do

      describe "and state has been added" do

        let(:added_state) do
          (1..3).reduce({}) do |result, i|
            result["key#{i}".to_sym] = "value#{i}"
            result
          end
        end

        before(:each) do
          added_state.each { |key, value| client_application_state[key] = value }
        end

        it "should update the session with the added state" do
          session.should_receive(:update).with(hash_including(added_state))

          client_application_state.save
        end

      end

    end

  end

  describe "#logged_in_to_live" do

    describe "when an access token has been established" do

      before(:each) { client_application_state[:access_token] = "some access token" }

      it "should return true" do
        client_application_state.logged_in_to_live?.should be_true
      end

    end

    describe "when an access token has not been established" do

      it "should return false" do
        client_application_state.logged_in_to_live?.should be_false
      end

    end

  end

  describe "#contains_customer_file" do

    describe "when a customer file token and id has been added" do

      before(:each) do
        client_application_state[:cf_token] = "some customer file token"
        client_application_state[:cf_id] = "some customer file id"
      end

      it "should return true" do
        client_application_state.contains_customer_file?.should be_true
      end

    end

    describe "when a customer file token has been added" do

      before(:each) { client_application_state[:cf_token] = "some customer file token" }

      it "should return false" do
        client_application_state.contains_customer_file?.should be_false
      end

    end

    describe "when a customer file id has been added" do

      before(:each) { client_application_state[:cf_id] = "some customer file id" }

      it "should return false" do
        client_application_state.contains_customer_file?.should be_false
      end

    end

    describe "when no customer file values have been added" do

      it "should return false" do
        client_application_state.contains_customer_file?.should be_false
      end

    end

  end

  describe "#logged_in_to_customer_file?" do

    it "should indicate whether the state contains a customer file" do
      client_application_state.method(:logged_in_to_customer_file?).should
        eql(client_application_state.method(:contains_customer_file?))
    end

  end

end
