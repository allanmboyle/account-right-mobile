module AccountRightMobile
  module Acceptance
    module Pages

      class CustomerFiles < Pages::Base

        def self.title
          "Customer Files"
        end

        def initialize(session, configuration)
          super(session, configuration)
        end

        def url
          "/#customer_files"
        end

        def access_a_file
          @session.find('#customer-files-list').all('a').first.click
        end

        def enter_credentials
          @session.fill_in("customer_file_username", :with => "cf_user")
          @session.fill_in("customer_file_password", :with => "cf_password")
        end

        def login
          @session.click_button("customer_file_login_submit")
        end

      end

    end
  end
end
