describe AccountRightMobile::Faker::CustomerFile do

  describe "#id" do

    it "should return a string in a conventional id format that contains 4 hyphens" do
      AccountRightMobile::Faker::CustomerFile.id.should match(/^[a-zA-Z0-9]*-[a-zA-Z_0-9]*-[a-zA-Z_0-9]*-[a-zA-Z_0-9]*/)
    end

    it "should return a unique string on each invocation" do
      AccountRightMobile::Faker::CustomerFile.id.should_not eql(AccountRightMobile::Faker::CustomerFile.id)
    end

  end

end
