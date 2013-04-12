describe AccountRight::API::Faker::CustomerFile do

  let(:customer_file_faker) { AccountRight::API::Faker::CustomerFile }

  describe "#id" do

    it "should return a string in a conventional id format that contains 4 hyphens" do
      customer_file_faker.id.should match(/^[a-zA-Z0-9]*-[a-zA-Z_0-9]*-[a-zA-Z_0-9]*-[a-zA-Z_0-9]*/)
    end

    it "should return a unique string on each invocation" do
      customer_file_faker.id.should_not eql(customer_file_faker.id)
    end

  end

end
