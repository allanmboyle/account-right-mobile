module AccountRightMobile
  module Acceptance
    module Pages

      class ContactDetails < Pages::Base

        def self.title
          "Contact Details"
        end

        def initialize(session, configuration)
          super(session, configuration)
        end

        def url
          "/#contact_details"
        end

        def contact
          wait_until_data_is_shown
          node = @session.find(".contact")
          node ? to_contact(node) : {}
        end

        def access_a_contact
          @session.all(".contact .name").first.click
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

        private

        def wait_until_data_is_shown
          wait_until_all_contain_text(".contact .name")
        end

        def to_contact(node)
          { name: node.find(".name").text(),
            type: node.find(".type").text(),
            balance: node.find(".balance").text(),
            phone_numbers: node.all(".phoneNumber").text(),
            email_address: node.find(".emailAddress").text(),
            address: node.all(".address .line").text() }
        end

      end

    end
  end
end
