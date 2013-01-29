module AccountRightMobile
  module Acceptance
    class DriverFactory
      IPHONE_USER_AGENT = 'Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_0 like Mac OS X; en-us) AppleWebKit/532.9 (KHTML, like Gecko) Version/4.0.5 Mobile/8A293 Safari/6531.22.7'
      IPHONE_DIMENSIONS = AccountRightMobile::Acceptance::Dimensions.new(width: 320, height: 480)

      def self.for(app)
        DriverFactory.new(app)
      end

      def create(name)
        if respond_to?(name)
          send("#{name}")
        else
          Capybara::Selenium::Driver.new(@app, :browser => name)
        end
      end

      def iphone
        Capybara::Selenium::Driver.new(@app, :browser => :iphone, :url => 'http://localhost:3001/wd/hub')
      end

      def firefox_iphone
        profile = Selenium::WebDriver::Firefox::Profile.new
        profile['general.useragent.override'] = IPHONE_USER_AGENT
        driver = Capybara::Selenium::Driver.new(@app, :browser => :firefox, :profile => profile)
        driver.browser.manage.window.size = IPHONE_DIMENSIONS
        driver
      end

      def chrome_iphone
        switches = ["--user-agent=#{IPHONE_USER_AGENT}"]
        driver = Capybara::Selenium::Driver.new(@app, :browser => :chrome, :switches => switches)
        driver.browser.manage.window.size = IPHONE_DIMENSIONS
        driver
      end

      private

      def initialize(app)
        @app = app
      end

    end
  end
end
