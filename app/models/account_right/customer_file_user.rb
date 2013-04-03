module AccountRight

  class CustomerFileUser < AccountRight::Base

    attr_accessor :username, :password

    def initialize(attributes = {})
      super(attributes)
    end

    def cf_token
      Base64.strict_encode64("#{username}:#{password}")
    end

    def login(customer_file_id, access_token)
      begin
        AccountRight::API.invoke("accountright/#{customer_file_id}/AccountingProperties",
                                 access_token: access_token, cf_token: cf_token)
      rescue AccountRight::API::AuthorizationFailure
        raise AccountRight::AuthenticationFailure
      rescue AccountRight::API::Error
        raise AccountRight::AuthenticationError
      end
    end

  end

end
