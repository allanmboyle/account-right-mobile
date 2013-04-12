module AccountRight
  module OAuth
    module Stub

      class Server < HttpServerManager::Server

        def initialize(options)
          super({ name: "oauth_stub_server" }.merge(options))
        end

        def start!
          super
          AccountRight::OAuth::Stub::Configurer.initialize!
          logger.info "#{@name} initialized"
        end

        def start_command
          "rake start_oauth_stub_server"
        end

      end

    end
  end
end
