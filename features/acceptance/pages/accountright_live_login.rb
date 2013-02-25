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

        def has_invalid_login_message?
          @session.has_css?("#live_login_fail_message-popup.ui-popup-active",
                            text: "The username or password you entered is incorrect",
                            visible: true)
        end

        def has_application_unavailable_message?
          @session.has_css?("#live_login_error_message-popup.ui-popup-active",
                            text: "We can't confirm your details at the moment, try again shortly",
                            visible: true)
        end

      end

    end
  end
end
