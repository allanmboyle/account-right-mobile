module AccountRightMobile

  class ClientApplicationState

    private

    STATE_KEYS = [:access_token, :refresh_token, :cf_id, :cf_token].freeze

    public

    def initialize(session)
      @session = session
      @state = STATE_KEYS.inject({}) do |result, key|
        result[key] = session[key]
        result
      end
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
