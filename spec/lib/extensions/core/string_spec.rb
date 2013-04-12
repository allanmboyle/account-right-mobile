describe Extensions::Core::String do

  describe "#contains_execution_error?" do

    describe "when the string contains 'no such file or directory'" do

      let(:string) { "some prefix no such file or directory some postfix" }

      it "should return true" do
        string.contains_execution_error?.should be_true
      end

    end

    describe "when the string contains 'command not found'" do

      let(:string) { "some other prefix command not found some other postfix" }

      it "should return true" do
        string.contains_execution_error?.should be_true
      end
                                                                                                                                                                                               \
    end

    describe "when the string contains some other characters" do

      let(:string) { "some other characters" }

      it "should return false" do
        string.contains_execution_error?.should be_false
      end

    end

    describe "when the string is empty" do

      let(:string) { "" }

      it "should return false" do
        string.contains_execution_error?.should be_false
      end

    end

  end

end
