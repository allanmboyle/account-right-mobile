describe AccountRight::LiveUser do

  let(:username) { "some_username" }
  let(:password) { "some_password" }

  let(:user) { AccountRight::LiveUser.new(username: username, password: password) }

  describe "#login" do

    it "should login the user using oAuth" do
      AccountRight::OAuth.should_receive(:login).with(username, password)

      user.login
    end

    it "should return the oAuth response" do
      oauth_response = {access_token: "some_access_token", refresh_token: "some_refresh_token"}

      AccountRight::OAuth.stub!(:login).and_return(oauth_response)

      user.login.should eql(oauth_response)
    end

  end

end
