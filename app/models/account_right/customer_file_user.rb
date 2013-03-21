module AccountRight

  class CustomerFileUser < AccountRight::Base

    attr_accessor :username, :password

    def initialize(attributes = {})
      super(attributes)
    end

    def cftoken
      Base64.encode64("#{username}:#{password}")
    end

    def login(customer_file_id, access_token)
      begin
        AccountRight::API.invoke("accountright/#{customer_file_id}/AccountingProperties", access_token, cftoken)
      rescue AccountRight::ApiError
        raise AccountRight::AuthenticationError
      end
    end

  end

end
