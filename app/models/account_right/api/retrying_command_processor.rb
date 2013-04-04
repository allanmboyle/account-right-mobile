module AccountRight
  module API

    class RetryingCommandProcessor

      class << self

        def execute(command)
          begin
            AccountRight::API::SimpleCommandProcessor.execute(command)
          rescue AccountRight::API::AuthorizationFailure
            retry_execute(command)
          end
        end

        private

        def retry_execute(command)
          re_login_response = AccountRight::OAuth.re_login(command.user_tokens[:refresh_token])
          command.user_tokens.save(access_token: re_login_response[:access_token],
                                   refresh_token: re_login_response[:refresh_token])
          AccountRight::API::SimpleCommandProcessor.execute(command)
        end

      end

    end

  end
end
