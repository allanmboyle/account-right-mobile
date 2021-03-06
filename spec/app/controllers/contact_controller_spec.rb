describe ContactController, type: :controller do

  let(:customer_file_id) { 8 }
  let(:client_application_state) { double(AccountRightMobile::ClientApplicationState).as_null_object }
  let(:contacts) { double(AccountRight::Contacts).as_null_object }
  let(:customer_file) { double(AccountRight::CustomerFile, contacts: contacts).as_null_object }

  before(:each) do
    AccountRightMobile::ClientApplicationState.stub!(:new).and_return(client_application_state)
    client_application_state.stub!(:[]).with(:cf_id).and_return(customer_file_id)

    AccountRight::CustomerFile.stub!(:new).and_return(customer_file)
  end

  describe "#index" do

    describe "GET" do

      describe "when a json request is made" do

        it "should require the user to be logged-in to AccountRight Live" do
          controller.should_receive(:require_live_login)

          get_index
        end

        it "should require the user to be logged-in to a Customer File" do
          controller.should_receive(:require_customer_file_login)

          get_index
        end

        it "should create a customer file customer file for the id in the users session" do
          AccountRight::CustomerFile.should_receive(:new).with(id: customer_file_id).and_return(customer_file)

          get_index
        end

        it "should create client application state encapsulating data in the users session" do
          AccountRightMobile::ClientApplicationState.should_receive(:new).with(session)
                                                                         .and_return(client_application_state)

          get_index
        end

        it "should retrieve the contacts from the customer file" do
          customer_file.should_receive(:contacts).with(client_application_state).and_return(contacts)

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
