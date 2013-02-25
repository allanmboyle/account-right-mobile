module AccountRight

  class LiveUser < AccountRight::Base
    include ::HTTParty

    base_uri "http://localhost:3002"

    attr_accessor :username, :password

    def initialize(attributes = {})
      super(attributes)
    end

    def login
      response = self.class.post("/oauth2/v1/authorise", body: { username: username, password: password })
      raise AccountRight::AuthenticationFailure if response.code >= 400 && response.code <= 499
      raise AccountRight::AuthenticationError if response.code >= 500
      JSON.parse(response.body).symbolize_keys
    end

  end

end
