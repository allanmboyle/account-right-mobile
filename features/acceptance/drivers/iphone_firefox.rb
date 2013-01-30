module AccountRightMobile
  module Acceptance
    module Drivers

      class IPhoneFirefox < AccountRightMobile::Acceptance::Drivers::Base

        USER_AGENT = "Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_0 like Mac OS X; en-us) AppleWebKit/532.9 (KHTML, like Gecko) Version/4.0.5 Mobile/8A293 Safari/6531.22.7"
        DIMENSIONS = Drivers::Dimensions.new(width: 320, height: 480)

        PROFILE = Selenium::WebDriver::Firefox::Profile.new do |profile|
          profile['general.useragent.override'] = USER_AGENT
        end

        def self.name
          :iphone_firefox
        end

        def initialize(options)
          super(options[:app], :browser => :firefox, :profile => PROFILE)
          browser.manage.window.size = DIMENSIONS
        end

      end

    end
  end
end