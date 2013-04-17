module AccountRightMobile
  module Acceptance
    module Selenium
      module Drivers

        class Default < AccountRightMobile::Acceptance::Selenium::Drivers::Base

          def self.name
            :default
          end

          def initialize(options)
            super(options[:app], :browser => options[:type])
          end

        end

      end
    end
  end
end
