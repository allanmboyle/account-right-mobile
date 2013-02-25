module AccountRightMobile
  module Services

    class OAuthStubServer < AccountRightMobile::Services::LocalServer

      def initialize(options)
        super({ name: "oauth_stub_server" }.merge(options))
      end

      def start!
        super
        AccountRightMobile::Services::OAuthStubConfigurer.initialize!
        @log.info "#{@name} initialized"
      end

      def start_command
        "rake start_oauth_stub_server"
      end

    end

  end
end
