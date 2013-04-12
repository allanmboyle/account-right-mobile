describe AccountRight::CustomerFile do

  let(:id) { "8" }
  let(:client_application_state) { double(AccountRightMobile::ClientApplicationState) }
  let(:customer_file) { AccountRight::CustomerFile.new(id: id) }

  describe ".all" do

    let(:customer_files_response) { "some customer files response" }

    before(:each) { AccountRight::API.stub!(:invoke).and_return(customer_files_response) }

    it "should invoke the API to retrieve the customer files based on the client application state" do
      AccountRight::API.should_receive(:invoke).with("accountright", client_application_state)

      AccountRight::CustomerFile.all(client_application_state)
    end

    it "should return the API response" do
      AccountRight::CustomerFile.all(client_application_state).should eql(customer_files_response)
    end

    it "should propagate any API error raised" do
      forced_error = AccountRight::API::ErrorFactory.create
      AccountRight::API.stub!(:invoke).and_raise(forced_error)

      lambda { AccountRight::CustomerFile.all(client_application_state) }.should raise_error(forced_error)
    end

  end

  describe ".find" do

    describe "when the client application state contains a customer file" do

      let(:customer_file_hash) { AccountRight::API::DataFactory.create_customer_file(Id: id) }
      let(:customer_files_response) { [ AccountRight::API::DataFactory.create_customer_file(),
                                        customer_file_hash,
                                        AccountRight::API::DataFactory.create_customer_file() ].to_json }

      before(:each) do
        client_application_state.stub!(:contains_customer_file?).and_return(true)
        client_application_state.stub!(:[]).with(:cf_id).and_return(id)
        AccountRight::CustomerFile.stub!(:all).and_return(customer_files_response)
      end

      it "should retrieve all customer files" do
        AccountRight::CustomerFile.should_receive(:all).and_return(customer_files_response)

        AccountRight::CustomerFile.find(client_application_state)
      end

      describe "when the customer files response contains the customer file in the client application state" do

        it "should return the json representation of the customer file" do
          AccountRight::CustomerFile.find(client_application_state).should eql(customer_file_hash.to_json)
        end

      end

      describe "when the customer files response does not contain the customer file in the client application state" do

        let(:customer_files_response) { [].to_json }

        it "should return an empty json hash" do
          AccountRight::CustomerFile.find(client_application_state).should eql("{}")
        end

      end

    end

    describe "when the client application state does not contain a customer file" do

      before(:each) { client_application_state.stub!(:contains_customer_file?).and_return(false) }

      it "should return an empty json hash" do
        AccountRight::CustomerFile.find(client_application_state).should eql("{}")
      end

    end

  end

  describe "#accounting_properties" do

    let(:accounting_properties_response) { "some accounting properties response" }

    before(:each) { AccountRight::API.stub!(:invoke).and_return(accounting_properties_response) }

    it "should invoke the API to retrieve the accounting properties for the customer file id" do
      AccountRight::API.should_receive(:invoke)
                       .with("accountright/#{id}/AccountingProperties", client_application_state)

      customer_file.accounting_properties(client_application_state)
    end

    it "should return the API response" do
      customer_file.accounting_properties(client_application_state).should eql(accounting_properties_response)
    end

    it "should propagate any API error raised" do
      forced_error = AccountRight::API::ErrorFactory.create
      AccountRight::API.stub!(:invoke).and_raise(forced_error)

      lambda { customer_file.accounting_properties(client_application_state) }.should raise_error(forced_error)
    end

  end

  describe "#contacts" do

    let(:contacts) { double(AccountRight::Contacts).as_null_object }
    let(:customer_response) { "some customer response" }
    let(:supplier_response) { "some supplier response" }

    before(:each) do
      AccountRight::Contacts.stub!(:new).and_return(contacts)

      AccountRight::API.stub!(:invoke).with(/.*Customer/, anything).and_return(customer_response)
      AccountRight::API.stub!(:invoke).with(/.*Supplier/, anything).and_return(supplier_response)
    end

    it "should invoke the API to retrieve the customers for the customer file id" do
      AccountRight::API.should_receive(:invoke).with("accountright/#{id}/Customer", client_application_state)
                                               .and_return(customer_response)

      customer_file.contacts(client_application_state)
    end

    it "should invoke the API to retrieve the suppliers for the customer file id" do
      AccountRight::API.should_receive(:invoke).with("accountright/#{id}/Supplier", client_application_state)
                                               .and_return(supplier_response)

      customer_file.contacts(client_application_state)
    end

    it "should create a contacts instance to hold the result" do
      AccountRight::Contacts.should_receive(:new).and_return(contacts)

      customer_file.contacts(client_application_state)
    end

    it "should add the retrieved customers to the contacts" do
      contacts.should_receive(:concat).with(customer_response, "Customer")

      customer_file.contacts(client_application_state)
    end

    it "should add the retrieved suppliers to the contacts" do
      contacts.should_receive(:concat).with(supplier_response, "Supplier")

      customer_file.contacts(client_application_state)
    end

    it "should return the contacts" do
      customer_file.contacts(client_application_state).should eql(contacts)
    end

    it "should propagate any API error raised" do
      forced_error = AccountRight::API::ErrorFactory.create
      AccountRight::API.stub!(:invoke).and_raise(forced_error)

      lambda { customer_file.contacts(client_application_state) }.should raise_error(forced_error)
    end

  end

end
