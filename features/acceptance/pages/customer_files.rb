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

        def username
          @session.find("#customer_file_username").value()
        end

        def access_a_file
          @session.all("#customer-files-list a").first.click
        end

        def customer_files
          wait_for_customer_files_to_have_text
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

        def has_invalid_credentials_message?
          @session.has_css?("#customer_file_login_fail_message-popup.ui-popup-active",
                            text: "The username or password you entered is incorrect",
                            visible: true)
        end

        def has_authentication_error_message?
          @session.has_css?("#customer_file_login_error_message-popup.ui-popup-active",
                            text: "We can't confirm your details at the moment, try again shortly",
                            visible: true)
        end

        private

        def wait_for_customer_files_to_have_text
          ::Wait.until_true!("all customer files contain text") do
            @session.all(".customer-file-name").reduce(true) { |result, node| result && !node.text().empty? }
          end
        end

      end

    end
  end
end
