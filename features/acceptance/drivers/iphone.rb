module AccountRightMobile
  module Acceptance
    module Drivers

      class IPhone < AccountRightMobile::Acceptance::Drivers::Base

        DEVICE_URL = "http://localhost:3001/wd/hub"

        def self.name
          :iphone
        end

        def initialize(options)
          super(options[:app], :browser => :iphone, :url => DEVICE_URL)
        end

      end

    end
  end
end