describe AccountRight::API::DataFactory do

  describe "#create_customer_file" do

    describe "constructs a hash that" do

      it "should contain a faked customer file id" do
        AccountRight::API::Faker::CustomerFile.should_receive(:id).and_return("some-faked-id")

        customer_file = AccountRight::API::DataFactory.create_customer_file

        customer_file[:Id].should eql("some-faked-id")
      end

      it "should contain a name that is a faked company name" do
        Faker::Company.should_receive(:name).and_return("Some Company Name")

        customer_file = AccountRight::API::DataFactory.create_customer_file

        customer_file[:Name].should eql("Some Company Name")
      end

    end

  end

  describe "#create_company" do

    describe "constructs a hash that" do

      it "should contain a CoLastName that is a faked company name" do
        Faker::Company.should_receive(:name).any_number_of_times.and_return("Some Company Name")

        company = AccountRight::API::DataFactory.create_company

        company[:CoLastName].should eql("Some Company Name")
      end

      it "should contain a FirstName that is empty" do
        company = AccountRight::API::DataFactory.create_company

        company[:FirstName].should be_empty
      end

      it "should contain an IsIndividual flag that is false" do
        company = AccountRight::API::DataFactory.create_company

        company[:IsIndividual].should be_false
      end

    end

  end

  describe "#create_individual" do

    describe "constructs a hash that" do

      it "should contain a CoLastName that is a faked last name" do
        Faker::Name.should_receive(:last_name).any_number_of_times.and_return("Some Last Name")

        individual = AccountRight::API::DataFactory.create_individual

        individual[:CoLastName].should eql("Some Last Name")
      end

      it "should contain a FirstName that is a faked first name" do
        Faker::Name.should_receive(:first_name).any_number_of_times.and_return("Some First Name")

        individual = AccountRight::API::DataFactory.create_individual

        individual[:FirstName].should eql("Some First Name")
      end

      it "should contain an IsIndividual flag that is true" do
        individual = AccountRight::API::DataFactory.create_individual

        individual[:IsIndividual].should be_true
      end

    end

  end

  describe "#create_contact_with_minimal_data" do

    describe "constructs a hash that" do

      it "should have a CoLastName" do
        contact = AccountRight::API::DataFactory.create_contact_with_minimal_data

        contact[:CoLastName].should_not be_empty
      end

      it "should have a CurrentBalance" do
        contact = AccountRight::API::DataFactory.create_contact_with_minimal_data

        contact[:CurrentBalance].should_not be_nil
      end

      it "should have an empty Addresses" do
        contact = AccountRight::API::DataFactory.create_contact_with_minimal_data

        contact[:Addresses].should be_empty
      end

    end

  end

end
