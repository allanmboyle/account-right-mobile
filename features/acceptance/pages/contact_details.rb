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
          node = @session.find("#contact-details .contact")
          node ? Fragments::ContactDetail.from_page_node(node) : Fragments::ContactDetail.new()
        end

        memoize :contact

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
          wait_until_all_contain_text("#contact-details .contact .name")
        end

      end

    end
  end
end
