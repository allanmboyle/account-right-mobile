shared_context "integration with an OAuth stub server" do
  include_context "managed http server integration utilities"

  let(:server) { AccountRight::OAuth::Stub::Server.new(port: 3002) }
end
