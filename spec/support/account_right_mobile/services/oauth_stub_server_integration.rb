shared_context "integration with an oAuth stub server" do
  include_context "managed http server integration utilities"

  let(:server) { AccountRightMobile::Services::OAuthStubServer.new(port: 3002) }
end
