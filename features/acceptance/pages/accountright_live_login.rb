module AccountRightMobile
  module Acceptance
    module Pages

      class AccountRightLiveLogin < Pages::Base

        def self.name
          "AccountRight Live Login"
        end

        def initialize(session)
          super(session)
        end

        def url
          "/"
        end

        def enter_credentials
          @session.fill_in("live_username", :with => "arl_user")
          @session.fill_in("live_password", :with => "arl_password")
        end

        def login
          @session.click_link("live_login_submit")
        end

        def shows_invalid_login_message!
          @session.has_content?("User credentials were invalid")
        end

        def shows_application_unavailable_message!
          @session.has_content?("application is temporarily unavailable")
        end

      end

    end
  end
end
