describe AccountRightMobile::OAuthServer do
  let(:description) { "oAuth Stub Server" }
  let(:port) { 3002 }
  let(:server) { AccountRightMobile::OAuthServer.new(port: port) }

  it_should_behave_like "a local server"

end
