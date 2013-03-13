module AccountRightMobile
  module Acceptance
    module Pages

      class AccountRightLiveLogin < Pages::Base

        def self.title
          "AccountRight Live Login"
        end

        def initialize(session, configuration)
          super(session, configuration)
        end

        def url
          "/"
        end

        def enter_credentials
          credentials = @configuration["live_user"]
          @session.fill_in("live_username", :with => credentials["username"])
          @session.fill_in("live_password", :with => credentials["password"])
        end

        def login
          @session.click_button("live_login_submit")
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
