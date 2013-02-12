module AccountRightMobile
  module Acceptance
    module Services

      class OAuthService
        include Http::Stub::Client

        URI = "/oauth2/v1/authorise"

        host "localhost"
        port 3002

        def grant_access
          stub!(URI,
                method: :post,
                response: { status: 200,
                            body: { refresh_token: "test_refresh_token", access_token: "test_access_token" }.to_json })
        end

        def deny_access
          stub!(URI, method: :post, response: { status: 403 })
        end

        def unavailable
          stub!(URI, method: :post, response: { status: 503 })
        end

      end

    end
  end
end
