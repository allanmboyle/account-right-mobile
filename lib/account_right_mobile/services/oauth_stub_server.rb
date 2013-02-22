module AccountRightMobile

  class OAuthStubServer < AccountRightMobile::LocalServer

    def initialize(options)
      super({ name: "oauth_stub_server" }.merge(options))
    end

    def start!
      super
      AccountRightMobile::OAuthStubConfigurer.initialize!
      @log.info "#{@name} initialized"
    end

    def start_command
      "rake start_oauth_stub_server"
    end

  end

end
