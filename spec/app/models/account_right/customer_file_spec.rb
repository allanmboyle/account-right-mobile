describe AccountRight::CustomerFile do

  let(:customer_file_id) { 8 }
  let(:user_tokens) { double(AccountRight::UserTokens) }
  let(:customer_file) { AccountRight::CustomerFile.new(customer_file_id) }

  describe "#accounting_properties" do

    let(:accounting_properties_response) { "some accounting properties response" }

    before(:each) { AccountRight::API.stub!(:invoke).and_return(accounting_properties_response) }

    it "should invoke the API to retrieve the accounting properties for the customer file id" do
      AccountRight::API.should_receive(:invoke)
                       .with("accountright/#{customer_file_id}/AccountingProperties", user_tokens)

      customer_file.accounting_properties(user_tokens)
    end

    it "should return the API response" do
      customer_file.accounting_properties(user_tokens).should eql(accounting_properties_response)
    end

    it "should propagate any API error raised" do
      forced_error = AccountRight::API::ErrorFactory.create
      AccountRight::API.stub!(:invoke).and_raise(forced_error)

      lambda { customer_file.accounting_properties(user_tokens) }.should raise_error(forced_error)
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
      AccountRight::API.should_receive(:invoke).with("accountright/#{customer_file_id}/Customer", user_tokens)
                                               .and_return(customer_response)

      customer_file.contacts(user_tokens)
    end

    it "should invoke the API to retrieve the suppliers for the customer file id" do
      AccountRight::API.should_receive(:invoke).with("accountright/#{customer_file_id}/Supplier", user_tokens)
                                               .and_return(supplier_response)

      customer_file.contacts(user_tokens)
    end

    it "should create a contacts instance to hold the result" do
      AccountRight::Contacts.should_receive(:new).and_return(contacts)

      customer_file.contacts(user_tokens)
    end

    it "should add the retrieved customers to the contacts" do
      contacts.should_receive(:concat).with(customer_response, "Customer")

      customer_file.contacts(user_tokens)
    end

    it "should add the retrieved suppliers to the contacts" do
      contacts.should_receive(:concat).with(supplier_response, "Supplier")

      customer_file.contacts(user_tokens)
    end

    it "should return the contacts" do
      customer_file.contacts(user_tokens).should eql(contacts)
    end

    it "should propagate any API error raised" do
      forced_error = AccountRight::API::ErrorFactory.create
      AccountRight::API.stub!(:invoke).and_raise(forced_error)

      lambda { customer_file.contacts(user_tokens) }.should raise_error(forced_error)
    end

  end

end
