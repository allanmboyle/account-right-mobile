module AccountRight

  class UserTokens

    def initialize(session)
      @session = session
      @tokens = { access_token: session[:access_token],
                  refresh_token: session[:refresh_token],
                  cf_token: session[:cf_token] }
    end

    def [](key)
      @tokens[key]
    end

    def []=(key, value)
      @tokens[key] = value
    end

    def save(hash={})
      @tokens.merge!(hash)
      @session.update(@tokens)
    end

  end

end
