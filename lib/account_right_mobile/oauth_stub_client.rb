module AccountRightMobile

  class OAuthStubClient
    include ::HttpStub::Client

    URI = "/oauth2/v1/authorise"

    host "localhost"
    port 3002

    def grant_access
      stub!(URI,
            method: :post,
            response: { status: 200,
                        body: { access_token: "test_access_token", refresh_token: "test_refresh_token" }.to_json })
    end

    def grant_access_for(credentials)
      stub!(URI,
            method: :post,
            parameters: credentials,
            response: { status: 200,
                        body: { access_token: "test_access_token", refresh_token: "test_refresh_token" }.to_json })
    end

    def deny_access
      stub!(URI, method: :post, response: { status: 400 })
    end

    def unavailable
      stub!(URI, method: :post, response: { status: 503 })
    end

  end

end
