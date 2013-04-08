module AccountRightMobile
  module Services
    module OAuthStub

      class Server < HttpServerManager::Server

        def initialize(options)
          super({ name: "oauth_stub_server" }.merge(options))
        end

        def start!
          super
          AccountRightMobile::Services::OAuthStub::Configurer.initialize!
          logger.info "#{@name} initialized"
        end

        def start_command
          "rake start_oauth_stub_server"
        end

      end

    end
  end
end
