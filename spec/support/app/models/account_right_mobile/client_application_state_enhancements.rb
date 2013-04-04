module AccountRightMobile
  module ClientApplicationStateEnhancements

    attr_reader :last_saved_state

    def self.included(mod)
      mod.alias_method_chain :save, :memoization
    end

    def save_with_memoization(*args)
      save_without_memoization(*args)
      @last_saved_state = @state.clone
    end

  end
end

AccountRightMobile::ClientApplicationState.send(:include, AccountRightMobile::ClientApplicationStateEnhancements)
