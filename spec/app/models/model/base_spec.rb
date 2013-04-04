describe Model::Base do

  describe "constructor" do

    it "should providing attributes by name" do
      model = Model::TestableModel.new(attribute1: "value1", attribute2: "value2", attribute3: "value3")

      model.attribute1.should eql("value1")
      model.attribute2.should eql("value2")
      model.attribute3.should eql("value3")
    end

  end

end
