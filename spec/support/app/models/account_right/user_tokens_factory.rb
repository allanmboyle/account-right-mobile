module AccountRight
  class UserTokensFactory

    def self.create(hash)
      AccountRight::UserTokens.new(StubSession.new.update(hash))
    end

  end
end
