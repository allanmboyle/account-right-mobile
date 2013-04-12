shared_examples_for "a shell command processor" do

  let(:lines) { %w{ line1 line2 line3 } }
  let(:ruby_statements) { lines.map { |line| "puts \"#{line}\";" } }
  let(:command) { "ruby -e '#{ruby_statements.join(" ")}'" }

  before(:each) { testable_processor.stub!(:puts) }

  it "should log the command to be executed to stdout" do
    testable_processor.should_receive(:puts).with(command)

    testable_processor.execute_with_logging(command)
  end

  it "should log each line of stdout from the command to stdout" do
    lines.each { |line| testable_processor.should_receive(:puts).with(/#{line}/) }

    testable_processor.execute_with_logging(command)
  end

  it "should return the combined stdout from the process" do
    result = testable_processor.execute_with_logging(command)

    lines.each { |line| result.should match(/#{line}/) }
  end

end
