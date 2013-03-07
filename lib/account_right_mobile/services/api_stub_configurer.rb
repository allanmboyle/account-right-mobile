module AccountRightMobile
  module Services

    class ApiStubConfigurer
      include ::HttpStub::Configurer

      URI = "/api2/v1/authorize"

      host "localhost"
      port 3003

      stub_activator "/grant_access", URI,
                     method: :post,
                     response: { status: 200,
                                 body: { access_token: "test_access_token",
                                         refresh_token: "test_refresh_token" }.to_json }

      stub_activator "/deny_access", URI, method: :post, response: { status: 400 }

      stub_activator "/misconfigure", URI, method: :post, response: { status: 401 }

      stub_activator "/unavailable", URI, method: :post, response: { status: 503 }

      def grant_access
        activate!("/grant_access")
      end

      def grant_access_for(credentials)
        stub!(URI,
              method: :post,
              parameters: credentials,
              response: { status: 200,
                          body: { access_token: "test_access_token", refresh_token: "test_refresh_token" }.to_json })
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

    end

  end
end
