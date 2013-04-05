module AccountRight

  class CustomerFileUser < Model::Base

    attr_accessor :customer_file, :username, :password

    def initialize(attributes = {})
      super(attributes)
    end

    def cf_token
      Base64.strict_encode64("#{username}:#{password}")
    end

    def login(client_application_state)
      client_application_state[:cf_id] = customer_file.id
      client_application_state[:cf_token] = cf_token
      begin
        customer_file.accounting_properties(client_application_state)
      rescue AccountRight::API::AuthorizationFailure
        raise AccountRight::AuthenticationFailure
      rescue AccountRight::API::Error
        raise AccountRight::AuthenticationError
      end
    end

  end

end
