module AccountRight

  class LiveUser < AccountRight::Base
    include ::HTTParty

    base_uri AccountRightMobile::Application.config.live_login["base_uri"]

    attr_accessor :username, :password

    def initialize(attributes = {})
      super(attributes)
    end

    def login
      response = self.class.post(AccountRightMobile::Application.config.live_login["path"],
                                 body: { username: username, password: password })
      raise AccountRight::AuthenticationFailure if response.code == 400
      raise AccountRight::AuthenticationError if response.code > 400
      JSON.parse(response.body).symbolize_keys
    end

  end

end
