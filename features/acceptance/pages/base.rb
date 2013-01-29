module AccountRightMobile
  module Acceptance
    module Pages

      class Base

        class << self

          def inherited(subclass)
            @page_classes ||= []
            @page_classes << subclass
          end

          def page_class_with_name(name)
            @page_classes.find { |page_class| page_class.name == name }.tap do |page_class|
              raise "Page with name '#{name}' not found" unless page_class
            end
          end

        end

        def initialize(session)
          @session = session
        end

        def visit
          @session.visit(url)
        end

        def shown?
          @session.has_content?(self.class.name)
        end

        def shown_without_error?
          shown? && @session.has_no_content?("error")
        end

      end

    end
  end
end
