module AccountRightMobile
  module Acceptance
    module Pages

      GENERAL_ERROR_MESSAGE = "An unexpected error has occurred"

      class Base

        class << self

          def inherited(subclass)
            @page_classes ||= []
            @page_classes << subclass
          end

          def page_class_with_title(title)
            @page_classes.find { |page_class| page_class.title == title }.tap do |page_class|
              raise "Page with title '#{title}' not found" unless page_class
            end
          end

        end

        def initialize(session, configuration)
          @session = session
          @configuration = configuration
        end

        def visit
          @session.visit(url)
        end

        def refresh
          @session.refresh
        end

        def shown?
          page_and_content_are_shown?.tap do |is_shown|
            wait_until_completely_shown if is_shown
          end
        end

        def shown_without_error?
          shown? && no_error_popups_are_shown?
        end

        protected

        def wait_until_all_contain_text(locator)
          ::Wait.until_true!("all nodes matching '#{locator}' contain text") do
            @session.all(locator).reduce(true) { |result, node| result && !node.text().empty? }
          end
        end

        private

        def page_and_content_are_shown?
          @session.has_selector?("##{self.class.element_id}", visible: true) &&
              @session.has_selector?("##{self.class.element_id} .ui-content", visible: true)
        end

        def wait_until_completely_shown
          # Intentionally blank
        end

        def no_error_popups_are_shown?
          @session.has_no_selector?("#{self.class.element_id} .ui-popup-active", text: /error/i)
        end

      end

    end
  end
end
