shared_context "integration with an API stub server" do
  include_context "managed http server integration utilities"

  let(:server) { AccountRight::API::Stub::Server.new(port: 3003) }
end
