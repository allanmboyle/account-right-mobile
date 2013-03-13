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
          @session.find("#customer-files-list").all("a").first.click
        end

        def customer_files
          @session.all(".customer-file-name").map { |node| node.text() }
        end

        def shows_login_within?(file_name)
          node = @session.all(".customer-file").find { |node| node.text().strip() =~ /^#{Regexp.escape(file_name)}/ }
          node && node.has_selector?("#customer-file-login-content")
        end

        def enter_credentials
          @session.fill_in("customer_file_username", :with => "cf_user")
          @session.fill_in("customer_file_password", :with => "cf_password")
        end

        def login
          @session.click_button("customer_file_login_submit")
        end

        def has_no_customer_files_available_message?
          @session.has_css?("#customer-files-content",
                            text: "No customer files are available to access at this time",
                            visible: true)
        end

        def has_application_unavailable_message?
          @session.has_css?("#general_error_message-popup.ui-popup-active",
                            text: GENERAL_ERROR_MESSAGE,
                            visible: true)
        end

      end

    end
  end
end
