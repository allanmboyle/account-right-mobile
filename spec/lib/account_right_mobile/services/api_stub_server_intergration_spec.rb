describe AccountRightMobile::Services::ApiStubServer do
  include_context "integration with an API stub server"

  it_should_behave_like "a managed http server"

end
