module AccountRight
  module OAuth
    module Stub

      class Configurer
        include ::HttpStub::Configurer

        private

        class << self

          attr_reader :last_access_token, :last_refresh_token

          def next_access_token
            @access_token_counter ||= 0
            @access_token_counter += 1
            @last_access_token = "accesstoken#{@access_token_counter.to_s.rjust(901, "A")}"
          end

          def next_refresh_token
            @refresh_token_counter ||= 0
            @refresh_token_counter += 1
            @last_refresh_token = "refreshtoken#{@access_token_counter.to_s.rjust(304, "R")}"
          end

        end

        public

        URI = "/oauth2/v1/authorize"

        host "localhost"
        port 3002

        stub_activator "/grant_access", URI,
                       method: :post,
                       response: { status: 200,
                                   body: { access_token: next_access_token, refresh_token: next_refresh_token }.to_json }

        stub_activator "/deny_access", URI, method: :post, response: { status: 400 }

        stub_activator "/misconfigure", URI, method: :post, response: { status: 401 }

        stub_activator "/unavailable", URI, method: :post, response: { status: 503 }

        activate!("/grant_access")

        def grant_access
          stub!(URI,
                method: :post,
                response: { status: 200,
                            body: { access_token: next_access_token, refresh_token: next_refresh_token }.to_json })
        end

        def grant_access_for_only(credentials)
          deny_access
          stub!(URI,
                method: :post,
                parameters: credentials,
                response: { status: 200,
                            body: { access_token: next_access_token, refresh_token: next_refresh_token }.to_json })
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
          self.class.last_access_token
        end

        def last_refresh_token
          self.class.last_refresh_token
        end

        private

        def next_access_token
          self.class.next_access_token
        end

        def next_refresh_token
          self.class.next_refresh_token
        end

      end

    end
  end
end
