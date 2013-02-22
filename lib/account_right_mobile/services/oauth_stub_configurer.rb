module AccountRightMobile

  class OAuthStubConfigurer
    include ::HttpStub::Configurer

    URI = "/oauth2/v1/authorise"

    host "localhost"
    port 3002

    stub_alias "/grant_access", URI,
               method: :post,
               response: { status: 200,
                           body: { access_token: "test_access_token", refresh_token: "test_refresh_token" }.to_json }

    stub_alias "/deny_access", URI, method: :post, response: { status: 400 }

    stub_alias "/unavailable", URI, method: :post, response: { status: 503 }

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

    def unavailable
      activate!("/unavailable")
    end

  end

end
