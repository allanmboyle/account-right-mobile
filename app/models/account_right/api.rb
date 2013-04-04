module AccountRight

  module API

    def self.invoke(resource_path, client_application_state)
      command = AccountRight::API::QueryCommand.new(resource_path, client_application_state)
      AccountRight::API::RetryingCommandProcessor.execute(command)
    end

  end

end
