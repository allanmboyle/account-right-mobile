module AccountRight

  class LiveUser < AccountRight::Base
    include ::HTTParty

    base_uri AccountRightMobile::Application.config.live_login["base_uri"]

    attr_accessor :username, :password

    def initialize(attributes = {})
      super(attributes)
    end

    def login
      response = self.class.post(login_config["path"], body: { client_id: login_config["client_id"],
                                                               client_secret: login_config["client_secret"],
                                                               scope: login_config["scope"],
                                                               username: username,
                                                               password: password })
      raise AccountRight::AuthenticationFailure if response.code == 400
      raise AccountRight::AuthenticationError if response.code > 400
      JSON.parse(response.body).symbolize_keys
    end

    private

    def login_config
      @login_config ||= AccountRightMobile::Application.config.live_login
    end

  end

end
