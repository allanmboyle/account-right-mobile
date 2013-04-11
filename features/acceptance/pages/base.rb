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

        def shown?
          @session.has_selector?('title', text: self.class.title)
        end

        def shown_without_error?
          shown? && @session.has_no_selector?(".ui-popup-active", text: /error/i)
        end

        protected

        def wait_until_all_contain_text(locator)
          ::Wait.until_true!("all nodes matching '#{locator}' contain text") do
            @session.all(locator).reduce(true) { |result, node| result && !node.text().empty? }
          end
        end

      end

    end
  end
end
