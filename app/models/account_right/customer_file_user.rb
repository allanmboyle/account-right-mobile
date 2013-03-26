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
      rescue AccountRight::ApiError => api_error
        error_type = api_error.response_code == 401 ? AccountRight::AuthenticationFailure :
                                                      AccountRight::AuthenticationError
        raise error_type
      end
    end

  end

end
