module AccountRightMobile
  module Acceptance
    module Pages

      APPLICATION_UNAVAILABLE_MESSAGE = "We can't confirm your details at the moment, try again shortly"

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
          shown? && @session.has_no_content?("error")
        end

      end

    end
  end
end
