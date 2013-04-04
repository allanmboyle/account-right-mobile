describe ContactController, type: :controller do

  let(:customer_file_id) { 8 }
  let(:user_tokens) { double(AccountRight::UserTokens).as_null_object }
  let(:contacts) { double(AccountRight::Contacts).as_null_object }
  let(:customer_file) { double(AccountRight::CustomerFile, contacts: contacts).as_null_object }

  before(:each) do
    session[:cf_id] = customer_file_id

    AccountRight::UserTokens.stub!(:new).and_return(user_tokens)
    AccountRight::CustomerFile.stub!(:new).and_return(customer_file)
  end

  describe "#index" do

    describe "GET" do

      describe "when a json request is made" do

        it "should create a customer file customer file for the id in the users session" do
          AccountRight::CustomerFile.should_receive(:new).with(customer_file_id).and_return(customer_file)

          get_index
        end

        it "should create user tokens encapsulating access to the tokens in the users session" do
          AccountRight::UserTokens.should_receive(:new).with(session).and_return(user_tokens)

          get_index
        end

        it "should retrieve the contacts from the customer file" do
          customer_file.should_receive(:contacts).with(user_tokens).and_return(contacts)

          get_index
        end

        it "should respond with a body containing the json representation of the contacts" do
          contacts.should_receive(:to_json).and_return("some json content")

          get_index

          response.body.should eql("some json content")
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

end
