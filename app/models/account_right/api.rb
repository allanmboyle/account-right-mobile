module AccountRight

  module API

    def self.invoke(resource_path, security_tokens)
      command = AccountRight::API::QueryCommand.new(resource_path, security_tokens)
      AccountRight::API::RetryingCommandProcessor.execute(command)
    end

  end

end
