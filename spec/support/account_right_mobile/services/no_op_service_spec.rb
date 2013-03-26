describe AccountRightMobile::Services::NoOpService do

  describe "when a class method is called" do

    let(:service_class) { AccountRightMobile::Services::NoOpService }

    it "should execute without error" do
      lambda { service_class.some_method("some argument") }.should_not raise_error
    end

    it "should act as a factory method, returning a new instance of the service" do
      result = service_class.some_method("some argument")

      result.should be_a(AccountRightMobile::Services::NoOpService)
    end

  end

  describe "when an instance method is called" do

    let(:service) { AccountRightMobile::Services::NoOpService.new }

    it "should execute without error" do
      lambda { service.some_method("some argument") }.should_not raise_error
    end

    it "should support method chaining by returning itself" do
      service.some_method("some argument").should eql(service)
    end

  end

end
