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
          @session.find("#customer-file-username").value()
        end

        def access_a_file
          customer_file_link = @session.all("#customer-files-list a").first
          customer_file_link.click unless customer_file_names.size == 1
          wait_until_login_is_shown
          customer_file_link.find(".customer-file-name").text()
        end

        def customer_file_names
          @session.all("#customer-files .customer-file-name").map { |node| node.text() }
        end

        memoize :customer_file_names

        def shows_login_within?(file_name)
          node = @session.all(".customer-file").find { |node| node.text().strip() =~ /^#{Regexp.escape(file_name)}/ }
          node && node.has_selector?("#customer-file-login-content")
        end

        def enter_credentials
          credentials = @configuration["customer_file_user"]
          @session.fill_in("customer-file-username", :with => credentials["username"])
          @session.fill_in("customer-file-password", :with => credentials["password"])
        end

        def login
          @session.click_button("customer-file-login-submit")
        end

        def logout
          @session.click_link("live-logout")
        end

        def has_no_customer_files_available_message?
          @session.has_css?("#customer-files-content",
                            text: "It looks like you're not online yet",
                            visible: true)
        end

        def has_re_login_required_message?
          @session.has_css?("#customer-file-re-login-required-message",
                            text: "Please log in again to continue",
                            visible: true)
        end

        def has_application_unavailable_message?
          @session.has_css?("#customer-files-general-error-message-popup.ui-popup-active",
                            text: GENERAL_ERROR_MESSAGE,
                            visible: true)
        end

        def has_invalid_credentials_message?
          @session.has_css?("#customer-file-login-fail-message-popup.ui-popup-active",
                            text: "The username or password you entered is incorrect",
                            visible: true)
        end

        def has_authentication_error_message?
          @session.has_css?("#customer-file-login-error-message-popup.ui-popup-active",
                            text: "We can't confirm your details at the moment, try again shortly",
                            visible: true)
        end

        private

        def wait_until_completely_shown
          wait_until_all_contain_text("#customer-files .customer-file-name")
        end

        def wait_until_login_is_shown
          ::Wait.until_true!("login is shown") { @session.find("#customer-file-login-content").visible? }
        end

      end

    end
  end
end
