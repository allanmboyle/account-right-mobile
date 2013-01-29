module AccountRightMobile
  module Acceptance
    module Drivers

      class DriverFactory

        def self.create(options)
          driver_class = Drivers::Base.driver_class_with_name(options[:type])
          driver_class ||= Drivers::Default
          driver_class.new(options)
        end

      end

    end
  end
end
