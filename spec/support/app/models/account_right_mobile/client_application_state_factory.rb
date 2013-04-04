module AccountRightMobile
  class ClientApplicationStateFactory

    def self.create(hash)
      AccountRightMobile::ClientApplicationState.new(StubSession.new.update(hash))
    end

  end
end
