describe AccountRightMobile::Faker::Money do

  shared_examples_for "a monetary value generator" do

    it "should have at most 2 decimal places" do
      result.to_s.should match(/\.\d\d?$/)
    end

    it "should have at least one digit before the decimal place" do
      result.to_s.should match(/^-?\d+\./)
    end

  end

  describe "#within" do

    shared_examples_for "a within invocation returning values within an expected range" do

      let(:result) { AccountRightMobile::Faker::Money.within(starting_price, ending_price) }

      it "should return a monetary value within the range of prices provided" do
        result.should be >= starting_price
        result.should be <= ending_price
      end

      it_should_behave_like "a monetary value generator"

    end

    describe "when provided a range that encompasses negative values" do

      let(:starting_price) { -10000.11 }
      let(:ending_price) { -1.00 }

      it_should_behave_like "a within invocation returning values within an expected range"

    end

    describe "when provided a range that encompasses positive values" do

      let(:starting_price) { 1.00 }
      let(:ending_price) { 22222222.88 }

      it_should_behave_like "a within invocation returning values within an expected range"

    end

    describe "when provided a range that encompasses negative and positive values" do

      let(:starting_price) { -22.66 }
      let(:ending_price) { 22.22 }

      it_should_behave_like "a within invocation returning values within an expected range"

    end

  end

  describe "#random" do

    let(:result) { AccountRightMobile::Faker::Money.random }

    it "should return a monetary value within + / - 10000" do
      result.should be >= -10000
      result.should be <= 10000
    end

    it_should_behave_like "a monetary value generator"

  end

end
