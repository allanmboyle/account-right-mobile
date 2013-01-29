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

        def enter_valid_credentials
          enter_credentials(username: "valid_arl_user", password: "valid_password")
        end

        def login
          @session.click_link("live_login_submit")
        end

        private

        def enter_credentials(options)
          @session.fill_in("live_username", :with => options[:username])
          @session.fill_in("live_password", :with => options[:password])
        end

      end

    end
  end
end
