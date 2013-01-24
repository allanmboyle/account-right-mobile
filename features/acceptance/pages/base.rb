module AccountRightMobile
  module Acceptance
    module Pages

      class Base

        def self.inherited(subclass)
          @page_classes ||= []
          @page_classes << subclass
        end

        def self.page_class_with_name(name)
          @page_classes.find { |page_class| page_class.name == name }.tap do |page_class|
            raise "Page with name '#{name}' not found" unless page_class
          end
        end

        def initialize(session)
          @session = session
        end

        def visit
          @session.visit(url)
        end

        def shown_without_error?
          shown? && @session.has_no_content?("error")
        end

        def wait_until_shown!
          AccountRightMobile::Acceptance::Wait.new(:message => "Timed-out waiting for #{self.class.name} page to be shown").until do
            shown?
          end
        end

        def wait_until_shown_without_error!
          AccountRightMobile::Acceptance::Wait.new(:message => "Timed-out waiting for #{self.class.name} page to be shown without error").until do
            shown_without_error?
          end
        end

      end

    end
  end
end
