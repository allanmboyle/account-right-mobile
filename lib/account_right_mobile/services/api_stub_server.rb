module AccountRightMobile
  module Services

    class ApiStubServer < AccountRightMobile::Services::LocalServer

      def initialize(options)
        super({ name: "api_stub_server" }.merge(options))
      end

      def start!
        super
        AccountRightMobile::Services::ApiStubConfigurer.initialize!
        @log.info "#{@name} initialized"
      end

      def start_command
        "rake start_api_stub_server"
      end

    end

  end
end
