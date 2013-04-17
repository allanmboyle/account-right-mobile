module AccountRightMobile
  module Acceptance
    module Selenium
      module Drivers

        class IPhone < AccountRightMobile::Acceptance::Selenium::Drivers::Base

          DEFAULT_HOST = "localhost"

          def self.name
            :iphone
          end

          def initialize(options)
            super(options[:app], :browser => :iphone, :url => url)
          end

          private

          def url
            "http://#{ENV["driver_host"] || DEFAULT_HOST}:3001/wd/hub"
          end

        end

      end
    end
  end
end
