module AccountRight

  class OAuth
    include HTTParty

    base_uri AccountRightMobile::Application.config.live_login["base_uri"]

    LOGIN_GRANT_TYPE = "password".freeze
    LOGIN_SCOPE = "CompanyFile".freeze
    RE_LOGIN_GRANT_TYPE = "refresh_token".freeze

    class << self

      def login(username, password)
        process_request(grant_type: LOGIN_GRANT_TYPE, scope: LOGIN_SCOPE, username: username, password: password)
      end

      def re_login(refresh_token)
        process_request(grant_type: RE_LOGIN_GRANT_TYPE, refresh_token: refresh_token)
      end

      private

      def process_request(credentials)
        resolved_credentials = {client_id: login_config["client_id"],
                                client_secret: login_config["client_secret"] }.merge(credentials)
        response = post(login_config["path"], body: resolved_credentials)
        Rails.logger.info("OAuth:: Path: #{login_config["path"]}\n\tCredentials: #{resolved_credentials}\n\tResponse: #{response.code} #{response.body}")
        raise AccountRight::AuthenticationFailure if response.code == 400
        raise AccountRight::AuthenticationError if response.code > 400
        JSON.parse(response.body).symbolize_keys
      end

      def login_config
        @login_config ||= AccountRightMobile::Application.config.live_login
      end

    end

  end

end
