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

        def enter_credentials
          @session.fill_in("customer_file_username", :with => "cf_user")
          @session.fill_in("customer_file_password", :with => "cf_password")
        end

        def login
          @session.click_link("customer_file_login_submit")
        end

      end

    end
  end
end
