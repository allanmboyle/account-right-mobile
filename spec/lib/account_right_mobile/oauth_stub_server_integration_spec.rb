describe AccountRightMobile::OAuthStubServer do
  include_context "integration with an oAuth stub server"

  it_should_behave_like "a local server"

end
