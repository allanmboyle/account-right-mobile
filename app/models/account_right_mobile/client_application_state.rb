module AccountRightMobile

  class ClientApplicationState

    def initialize(session)
      @session = session
      @state = { access_token: session[:access_token],
                 refresh_token: session[:refresh_token],
                 cf_token: session[:cf_token] }
    end

    def [](key)
      @state[key]
    end

    def []=(key, value)
      @state[key] = value
    end

    def save(hash={})
      @state.merge!(hash)
      @session.update(@state)
    end

  end

end
