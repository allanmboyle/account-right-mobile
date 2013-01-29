module AccountRightMobile
  module Acceptance
    module Pages

      class CustomerFileLogin < Pages::Base

        def self.name
          "Customer File Login"
        end

        def initialize(session)
          super(session)
        end

        def url
          "/#customer_file_login"
        end

        def enter_valid_credentials
          enter_credentials(username: "valid_cf_user", password: "valid_password")
        end

        def login
          @session.click_link("customer_file_login_submit")
        end

        private

        def enter_credentials(options)
          @session.fill_in("customer_file_username", :with => options[:username])
          @session.fill_in("customer_file_password", :with => options[:password])
        end

      end

    end
  end
end
