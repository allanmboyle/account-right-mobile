describe Extensions::Core::Object do

  let(:testable_module) { Module.new }

  describe ".included" do

    before(:each) { testable_module.stub!(:include) }

    describe "when PTY is available" do

      before(:each) { Extensions::Core::Object.stub!(:require).with('pty') }

      it "should include the PTY command processor" do
        testable_module.should_receive(:include).with(Extensions::Core::Object::PTYCommandProcessor)

        Extensions::Core::Object.included(testable_module)
      end

    end

    describe "when PTY is unavailable" do

      before(:each) { Extensions::Core::Object.stub!(:require).with('pty').and_raise(LoadError, "Forced error") }

      it "should include the IO command processor" do
        testable_module.should_receive(:include).with(Extensions::Core::Object::IOCommandProcessor)

        Extensions::Core::Object.included(testable_module)
      end

    end

  end

end
