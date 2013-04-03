module AccountRight

  module API

    def self.invoke(resource_path, security_tokens)
      AccountRight::API::RetryingQueryExecutor.execute(AccountRight::API::Query.new(resource_path, security_tokens))
    end

  end
end
