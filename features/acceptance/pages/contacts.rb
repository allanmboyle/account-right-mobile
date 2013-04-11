module AccountRightMobile
  module Acceptance
    module Pages

      class Contacts < Pages::Base

        def self.title
          "Contacts"
        end

        def initialize(session, configuration)
          super(session, configuration)
        end

        def url
          "/#contacts"
        end

        def contacts
          wait_until_all_contacts_are_shown
          @session.all("#contacts .contact").map { |node| Fragments::ContactOverview.from_page_node(node) }
        end

        memoize :contacts

        def access_a_contact
          @session.all("#contacts .contact .name").first.click
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

        def wait_until_all_contacts_are_shown
          wait_until_all_contain_text("#contacts .contact .name")
        end

      end

    end
  end
end
