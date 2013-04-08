module AccountRightMobile
  module Services
    module ApiStub

      class Server < HttpServerManager::Server

        def initialize(options)
          super({ name: "api_stub_server" }.merge(options))
        end

        def start!
          super
          AccountRightMobile::Services::ApiStub::Configurer.initialize!
          logger.info "#{@name} initialized"
        end

        def start_command
          "rake start_api_stub_server"
        end

      end

    end
  end
end
