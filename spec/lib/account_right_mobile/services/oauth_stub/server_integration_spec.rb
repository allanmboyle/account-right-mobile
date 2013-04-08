describe AccountRightMobile::Services::OAuthStub::Server do
  include_context "integration with an OAuth stub server"

  it_should_behave_like "a managed http server"

end
