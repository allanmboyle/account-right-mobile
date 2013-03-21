module AccountRightMobile
  module Services

    class OAuthStubServer < HttpServerManager::Server

      def initialize(options)
        super({ name: "oauth_stub_server" }.merge(options))
      end

      def start!
        super
        AccountRightMobile::Services::OAuthStubConfigurer.initialize!
        logger.info "#{@name} initialized"
      end

      def start_command
        "rake start_oauth_stub_server"
      end

    end

  end
end
