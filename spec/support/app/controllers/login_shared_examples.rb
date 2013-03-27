shared_examples_for "a login action that has standard responses to failure scenarios" do

  describe "when the user login is unsuccessful" do

    before(:each) do
      user.stub!(:login).and_raise(AccountRight::AuthenticationFailure)
    end

    it "should respond with a status of 401" do
      post_login

      response.status.should eql(401)
    end

  end

  describe "when the user login causes an error" do

    before(:each) do
      user.stub!(:login).and_raise(AccountRight::AuthenticationError)
    end

    it "should respond with a status of 500" do
      post_login

      response.status.should eql(500)
    end

  end

end
