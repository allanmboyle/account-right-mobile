describe AccountRightMobile::Services::OAuthStubServer do
  include_context "integration with an oAuth stub server"

  it_should_behave_like "a managed http server"

end
