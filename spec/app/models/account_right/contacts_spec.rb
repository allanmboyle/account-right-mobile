describe AccountRight::Contacts do

  let(:contacts_values) do
    (1..3).map do |i|
      { "Some Key #{i}" => "Some Value #{i}" }
    end
  end

  let(:contacts_json) do
    { "Items" => contacts_values }.to_json
  end

  let(:contacts) { AccountRight::Contacts.new }

  describe "#concat" do

    it "should add a Type attribute to each contact whose value is the type provided" do
      contacts.concat(contacts_json, "Some Type")

      contact_types = JSON.parse(contacts.to_json).map { |contact| contact["Type"] }

      contact_types.should eql(["Some Type"] * 3)
    end

    it "should return the contacts to support method chaining" do
      contacts.concat(contacts_json, "Some Type").should eql(contacts)
    end

  end

  describe "#to_json" do

    describe "when contacts have been added" do

      before(:each) { contacts.concat(contacts_json, "Some Type") }

      it "should return a json representation" do
        expected_values = contacts_values.each { |contact| contact["Type"] = "Some Type" }

        JSON.parse(contacts.to_json).should eql(expected_values)
      end

    end

  end

end
