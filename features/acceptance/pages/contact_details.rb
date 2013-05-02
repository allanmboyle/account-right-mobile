module AccountRightMobile
  module Acceptance
    module Pages

      class ContactDetails < Pages::Base

        class << self

          def title
            "Contact details"
          end

          def element_id
            "contact-details"
          end

        end

        def initialize(session, configuration)
          super(session, configuration)
        end

        def url
          "/#contact_details"
        end

        def customer_file_name
          @session.find("#contact-details .customer-file-name").text()
        end

        def contact
          @contact ||= create_contact
        end

        def back
          @session.click_link("contacts-back")
        end

        def has_no_contacts_available_message?
          @session.has_css?("#contacts-content",
                            text: "No contacts are available to access at this time",
                            visible: true)
        end

        def has_application_unavailable_message?
          @session.has_css?("#contacts-general-error-message-popup.ui-popup-active",
                            text: GENERAL_ERROR_MESSAGE,
                            visible: true)
        end

        def to_fragment(api_model, type)
          Fragments::ContactDetail.from_api_model(api_model, type)
        end

        private

        def create_contact
          node = @session.find("#contact-details .contact")
          node ? Fragments::ContactDetail.from_page_node(node) : Fragments::ContactDetail.new()
        end

        def wait_until_completely_shown
          wait_until_back_button_is_shown
          wait_until_customer_file_is_shown
          wait_until_contact_is_shown
        end

        def wait_until_back_button_is_shown
          wait_until_all_contain_text("#contacts-back .ui-btn-text")
        end

        def wait_until_customer_file_is_shown
          wait_until_all_contain_text("#contact-details .customer-file-name")
        end

        def wait_until_contact_is_shown
          wait_until_all_contain_text("#contact-details .contact .name")
        end

      end

    end
  end
end
