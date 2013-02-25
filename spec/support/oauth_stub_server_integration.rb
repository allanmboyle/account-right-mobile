shared_context "integration with an oAuth stub server" do
  include_context "server lifecycle utilities"

  let(:description) { "oAuth Stub Server" }
  let(:port) { 3002 }
  let(:pid_file_name) { "oauth_stub_server.pid" }
  let(:server) { AccountRightMobile::Services::OAuthStubServer.new(port: port) }
end
