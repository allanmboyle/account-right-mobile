shared_context "integration with an API stub server" do
  include_context "server lifecycle utilities"

  let(:description) { "API Stub Server" }
  let(:port) { 3003 }
  let(:pid_file_name) { "api_stub_server.pid" }
  let(:server) { AccountRightMobile::Services::ApiStubServer.new(port: port) }
end
