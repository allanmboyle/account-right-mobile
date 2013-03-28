module AccountRightMobile
  module Services

    class OAuthStubConfigurer
      include ::HttpStub::Configurer

      URI = "/oauth2/v1/authorize"
      ACCESS_TOKEN = "A" * 912
      REFRESH_TOKEN = "test_refresh_token"

      host "localhost"
      port 3002

      stub_activator "/grant_access", URI,
                     method: :post,
                     response: { status: 200,
                                 body: { access_token: ACCESS_TOKEN, refresh_token: REFRESH_TOKEN }.to_json }

      stub_activator "/deny_access", URI, method: :post, response: { status: 400 }

      stub_activator "/misconfigure", URI, method: :post, response: { status: 401 }

      stub_activator "/unavailable", URI, method: :post, response: { status: 503 }

      activate!("/grant_access")

      def grant_access
        activate!("/grant_access")
      end

      def grant_access_for(credentials)
        stub!(URI,
              method: :post,
              parameters: credentials,
              response: { status: 200,
                          body: { access_token: ACCESS_TOKEN, refresh_token: REFRESH_TOKEN }.to_json })
      end

      def deny_access
        activate!("/deny_access")
      end

      def misconfigure
        activate!("/misconfigure")
      end

      def unavailable
        activate!("/unavailable")
      end

      def last_access_token
        ACCESS_TOKEN
      end

      def last_refresh_token
        REFRESH_TOKEN
      end

    end

  end
end
