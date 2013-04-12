describe Extensions::Core::Object::IOCommandProcessor do

  class TestableIOCommandProcessor
    include Extensions::Core::Object::IOCommandProcessor
  end

  let(:testable_processor) { TestableIOCommandProcessor.new }

  describe "#execute_with_logging" do

    it_should_behave_like "a shell command processor" do

      it "should open a process executing the command via IO" do
        IO.should_receive(:popen).with(command)

        testable_processor.execute_with_logging(command)
      end

    end

  end

end
