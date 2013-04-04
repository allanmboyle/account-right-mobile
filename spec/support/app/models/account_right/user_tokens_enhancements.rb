module AccountRight
  module UserTokensEnhancements

    attr_reader :last_saved_tokens

    def self.included(mod)
      mod.alias_method_chain :save, :memoization
    end

    def save_with_memoization(*args)
      save_without_memoization(*args)
      @last_saved_tokens = @tokens.clone
    end

  end
end

AccountRight::UserTokens.send(:include, AccountRight::UserTokensEnhancements)
