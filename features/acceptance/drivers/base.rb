module AccountRightMobile
  module Acceptance
    module Drivers

      class Base < Capybara::Selenium::Driver

        class << self

          def inherited(subclass)
            @driver_classes ||= []
            @driver_classes << subclass
          end

          def driver_class_with_name(name)
            @driver_classes.find { |driver_class| driver_class.name == name }
          end

        end

        def initialize(*args)
          super(*args)
        end

      end

    end
  end
end