module AccountRightMobile
  module Acceptance
    module Pages

      class LiveLogin < Pages::Base

        def self.title
          "AccountRight Live log in"
        end

        def initialize(session, configuration)
          super(session, configuration)
        end

        def url
          "/"
        end

        def enter_credentials
          credentials = @configuration["live_user"]
          @session.fill_in("live_email_address", :with => credentials["username"])
          @session.fill_in("live_password", :with => credentials["password"])
        end

        def login
          @session.click_button("live-login-submit")
        end

        def has_login_required_message?
          @session.has_css?("#live-login-required-message",
                            text: "Please log in to continue",
                            visible: true)
        end

        def has_invalid_credentials_message?
          @session.has_css?("#live-login-fail-message-popup.ui-popup-active",
                            text: "The username or password you entered is incorrect",
                            visible: true)
        end

        def has_authentication_error_message?
          @session.has_css?("#live-login-error-message-popup.ui-popup-active",
                            text: "We can't confirm your details at the moment, try again shortly",
                            visible: true)
        end

      end

    end
  end
end
