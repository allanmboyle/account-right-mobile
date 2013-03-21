shared_context "integration with an API stub server" do
  include_context "managed http server integration utilities"

  let(:server) { AccountRightMobile::Services::ApiStubServer.new(port: 3003) }
end
