describe Extensions::Core::Object::PTYCommandProcessor do

  class TestablePTYCommandProcessor
    include Extensions::Core::Object::PTYCommandProcessor
  end

  let(:testable_processor) { TestablePTYCommandProcessor.new }

  describe "#execute_with_logging" do

    it_should_behave_like "a shell command processor" do

      it "should spawn a process executing the command via PTY" do
        PTY.should_receive(:spawn).with(command)

        testable_processor.execute_with_logging(command)
      end

    end

  end

end if defined?(PTY)
