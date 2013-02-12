module AccountRightMobile
  class OAuthServer < AccountRightMobile::LocalServer

    def initialize(options)
      super({ name: "oauth_server" }.merge(options))
    end

    def start_command
      "rake start_oauth_server"
    end

  end
end
