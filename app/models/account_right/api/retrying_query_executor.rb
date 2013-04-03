module AccountRight
  module API

    class RetryingQueryExecutor

      class << self

        def execute(query)
          begin
            AccountRight::API::SimpleQueryExecutor.execute(query)
          rescue AccountRight::API::AuthorizationFailure
            retry_execution_of(query)
          end
        end

        private

        def retry_execution_of(query)
          re_login_response = AccountRight::OAuth.re_login(query.security_tokens[:refresh_token])
          query.security_tokens[:access_token] = re_login_response[:access_token]
          query.security_tokens[:refresh_token] = re_login_response[:refresh_token]
          AccountRight::API::SimpleQueryExecutor.execute(query)
        end

      end

    end

  end
end
