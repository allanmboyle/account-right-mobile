module AccountRightMobile
  module Acceptance
    module Pages

      class Contacts < Pages::Base

        FILTER_BY_NAME_INPUT_SELECTOR = "#contacts-content .ui-listview-filter input"

        class << self

          def title
            "Contacts"
          end

          def element_id
            "contacts"
          end

        end

        def initialize(session, configuration)
          super(session, configuration)
        end

        def url
          "/#contacts"
        end

        def customer_file_name
          @session.find("#contacts .customer-file-name").text()
        end

        def contacts
          @contacts ||= @session.all("#contacts .contact", visible: true).map do |node|
            Fragments::ContactOverview.from_page_node(node)
          end
        end

        def filter_by_name(text)
          @session.find(FILTER_BY_NAME_INPUT_SELECTOR).set(text)
          @contacts = nil
        end

        def filter_by_they_owe
          @session.choose("contacts-they-owe-filter")
        end

        def filter_by_i_owe
          @session.choose("contacts-i-owe-filter")
        end

        def access_a_contact
          @session.all("#contacts .contact .name").first.click
        end

        def logout
          @session.click_link("customer-file-logout")
        end

        def has_no_contacts_filters?
          has_no_by_balance_filter? && has_no_by_name_filter?
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

        def to_fragments(api_models, type)
          api_models.map { |model| Fragments::ContactOverview.from_api_model(model, type) }
        end

        private

        def wait_until_completely_shown
          wait_until_logout_button_is_shown
          wait_until_customer_file_is_shown
          wait_until_all_contacts_are_shown
        end

        def wait_until_logout_button_is_shown
          wait_until_all_contain_text("#customer-file-logout .ui-btn-text")
        end

        def wait_until_customer_file_is_shown
          wait_until_all_contain_text("#contacts .customer-file-name")
        end

        def wait_until_all_contacts_are_shown
          wait_until_all_contain_text("#contacts .contact .name")
        end

        def has_no_by_balance_filter?
          @session.has_css?("#contacts-content .balance-filter", visible: false)
        end

        def has_no_by_name_filter?
          @session.has_css?(FILTER_BY_NAME_INPUT_SELECTOR, visible: false)
        end

      end

    end
  end
end
